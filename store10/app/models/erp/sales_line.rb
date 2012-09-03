class ERP::SalesLine < ActiveRecord::Base
  include ERPSupport
  
  belongs_to :sales_order, :foreign_key => "erp_sales_order_id"
  belongs_to :product, :foreign_key => "item_id", :class_name => "ERP::Product"
  
  attr_accessor :status
  def status
    return @status unless @status.blank? # Over-write this attribute for a VIRTUAL order
    return "Completed" if self.remain_sales_physical <= 0
    return "In Process" if self.sales_order.document_status == "PickingList"
    return "Backorder" if self.sales_order.sales_status == "Backorder"
    return "Open"
  end
  
  # Before Save was Triggering an error with saving new records. Reset to always return true.
  def before_save
    if not sales_order.new_record?
      remain_sales_physical ||= sales_qty
    end
    return true
  end
  
  def after_save
    sales_order.mark_as_modified
  end
  
  def after_destoy
    sales_order.mark_as_modified
  end
  
  def modifiable?
    sales_order.document_status == 'None' &&
      sales_order.sales_status == 'Backorder' &&
      self.item_id != '101001' &&    # sales line of RED ONE Body is always un-modifiable.
      remain_sales_physical > 0
  end
  
  # Update sales quantity of this sales line. Line amount will be re-calculated
  #   using new quantity and discount amount (if available).
  def update_sales_qty( new_qty )
    return sales_qty unless modifiable?
    return sales_qty if new_qty < remain_sales_physical
    if update_attributes( :sales_qty => new_qty, :line_amount => new_qty * display_price )
      return new_qty
    else
      return sales_qty
    end
  end
  
  # Calculated price for displaying
  def display_price
    price = self.sales_price || (self.product && self.product.price)
    if price.blank?
      item = ERP::Item.find_by_item_id(self.item_id)
      price = item.price
    end
    
    return price
  end
  
  # Move current sales line to another order
  def move_to_order( target_order )
    if !self.modifiable?
      self.sales_order.errors.add :sales_lines, "Modification on completed sales line denied."
      return false
    elsif target_order.nil?
      self.sales_order.errors.add :sales_lines, "Target order does not exist."
      return false
    end
    
    self.sales_order.class.transaction( self, target_order ) do
      moving_qty = self.remain_sales_physical
      
      # Reduce both the "Sales Qty" & "Remain Qty" of current sales line
      self.sales_qty -= moving_qty
      # self.remain_sales_physical -= moving_qty
      self.sales_qty.zero? ? self.destroy : self.save!
      
      # Add these movied items to target order
      existing_sales_line = target_order.sales_lines.find_by_item_id( self.item_id )
      if existing_sales_line.nil? || !existing_sales_line.modifiable?
        # No lines with status "open" found in target order. Create an new sales line.
        target_order.sales_lines.create! :sales_qty => moving_qty, :item_id => self.item_id, :remain_sales_physical => self.remain_sales_physical, :line_amount => self.line_amount, :sales_price => self.sales_price
      else
        # Sales line with same "Item Id" found in target order.
        existing_sales_line.sales_qty += moving_qty
        # existing_sales_line.remain_sales_physical += moving_qty
        existing_sales_line.save!
      end
      
      # Return "TRUE" after updating successfully.
      return true
    end
  end
end

# belongs_to does not support "primary_key" options.
# Providing another model for this association in SalesLine.
# NOTE:
#   Do NOT execute ANY update operations via this model.
class ERP::Product < Product
  set_table_name "products"
  set_primary_key "erp_product_item"
  
  # Return the ID as reference primary key insteat of the FAKE id ("code")
  def id
    attributes["id"]
  end
end