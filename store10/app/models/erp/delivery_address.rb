class ERP::DeliveryAddress < ERP::Address
  belongs_to :sales_order, :class_name => "ERP::SalesOrder", :foreign_key => "parent_id"
  
  def after_update
    self.sales_order.mark_as_modified
  end
end
