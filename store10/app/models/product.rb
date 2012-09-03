class Product < ActiveRecord::Base
  has_many :order_line_items
  has_and_belongs_to_many :images
  has_and_belongs_to_many :tags
  validates_presence_of :name

  #==============================================
  # Const for all sticker erp product item number
  #==============================================
  REDONE_ERP_PRODUCT_ITEM   = '101001'
  STICKER_ERP_PRODUCT_ITEMS = [
    '901003','901002','901001','901004',
    '901005','901006','901007','901008'
  ]
  
  T_SHIRTS = [
    {:code => "902001", :sex => "men", :color => "white", :size => "m"},
    {:code => "902002", :sex => "men", :color => "white", :size => "l"},
    {:code => "902003", :sex => "men", :color => "white", :size => "xl"},
    {:code => "902004", :sex => "men", :color => "white", :size => "xxl"},
    {:code => "902005", :sex => "men", :color => "red", :size => "m"},
    {:code => "902006", :sex => "men", :color => "red", :size => "l"},
    {:code => "902007", :sex => "men", :color => "red", :size => "xl"},
    {:code => "902008", :sex => "men", :color => "red", :size => "xxl"},
    {:code => "902009", :sex => "women", :color => "white", :size => "s"},
    {:code => "902010", :sex => "women", :color => "white", :size => "m"},
    {:code => "902011", :sex => "women", :color => "white", :size => "l"},
    {:code => "902012", :sex => "women", :color => "white", :size => "xl"},
    {:code => "902013", :sex => "women", :color => "red", :size => "s"},
    {:code => "902014", :sex => "women", :color => "red", :size => "m"},
    {:code => "902015", :sex => "women", :color => "red", :size => "l"},
    {:code => "902016", :sex => "women", :color => "red", :size => "xl"},
    {:code => "902017", :sex => "men", :color => "black", :size => "m"},
    {:code => "902018", :sex => "men", :color => "black", :size => "l"},
    {:code => "902019", :sex => "men", :color => "black", :size => "xl"},
    {:code => "902020", :sex => "men", :color => "black", :size => "xxl"},
    {:code => "902021", :sex => "women", :color => "black", :size => "s"},
    {:code => "902022", :sex => "women", :color => "black", :size => "m"},
    {:code => "902023", :sex => "women", :color => "black", :size => "l"},
    {:code => "902024", :sex => "men", :color => "black", :size => "xxxxl"},
    {:code => "902025", :sex => "men", :color => "white", :size => "xxxxl"},
    {:code => "902026", :sex => "men", :color => "red", :size => "xxxxl"}
  ]
  
  T_SHIRT_ERP_PRODUCT_ITEMS = T_SHIRTS.map { |t_shirt| t_shirt[:code] }
  
  PAID_TODAY_ERP_PRODUCT_ITEMS = STICKER_ERP_PRODUCT_ITEMS + T_SHIRT_ERP_PRODUCT_ITEMS
  
  PAID_TODAY_FREIGHT_IN_US  = 9.81
  PAID_TODAY_FREIGHT_OUT_US = 47.18
  
  
  def read_display_order(product_id,tag_id)
    ActiveRecord::Base.connection.select_one("SELECT product_sort_id FROM products_tags where product_id = #{product_id} and tag_id = #{tag_id}")
  end
  # ===========================================================================================================================================
  # = Code 0: Image “✓”, Message “Usually ships in 3-5 business days”, Rule Qty > 50                                                          =
  # = Code 1: Image “∅”(Clock), Message “Usually ships within 1-2 weeks”, Rule Qty > 25, Qty < 50                                             =
  # = Code 2: Image “✆”(Call), Message “Limited quantities available.  Please call +1-949.206.7900 for more details”, Rule Qty > 0, Qty < 25  =
  # = Code 9: Image “✘”, Message “Currently out of stock”, Rule Qty = 0                                                                       =   
  # ===========================================================================================================================================
  def delivery_code
    if (self.attributes["delivery_code"]).blank?
      qty = self.quantity.to_i
      if qty > 50
        0
      elsif (26...50).include?(qty)
        1
      elsif (1...25).include?(qty)
        2
      elsif qty == 0
        9
      end
    else
      (self.attributes["delivery_code"])
    end
  end

  # def delivery_message 
  #   if (self.attributes["delivery_message"]).blank?
  #     case self.delivery_code.to_i
  #     when 0
  #       "Usually ships in 3-5 business days"
  #     when 1
  #       "Usually ships within 1-2 weeks"
  #     when 2
  #       "Limited quantities available.  Please call +1-949.206.7900 for more details"
  #     when 9
  #       "Currently out of stock"
  #     end
  #   else
  #     self.attributes["delivery_message"]
  #   end 
  # end
  
  # Defined to find t_shirts from products
  def self.find_t_shirt(sex, color, size)
    t_shirt = T_SHIRTS.find { |t| t[:sex] == sex && t[:color] == color && t[:size] == size }
    t_shirt.nil? ? nil : self.find_by_code(t_shirt[:code])
  end 

  # Searches for products
  # Uses product name, code, or description
  def self.search(search_term, count=false, limit_sql=nil)
    if (count == true) then
      sql = "SELECT COUNT(*) "
    else
      sql = "SELECT DISTINCT * "
    end
    sql << "FROM products "
    sql << "WHERE name LIKE ? "
    sql << "OR description LIKE ? "
    sql << "OR code LIKE ? "
    sql << "ORDER BY date_available DESC "
    sql << "LIMIT #{limit_sql}" if limit_sql
    arg_arr = [sql, "%#{search_term}%", "%#{search_term}%", "%#{search_term}%"]
    if (count == true) then
      count_by_sql(arg_arr)
    else
      find_by_sql(arg_arr)
    end
  end 


  # def self.search_by_delivery_code(code)
  #   products = self.find :all
  #   products.select {|product| product.delivery_code  == code}
  # end
  # Finds products by list of tag ids passed in
  #
  # We could JOIN multiple times, but selecting IN grabs us the products
  # and using GROUP BY & COUNT with the number of tag id's given
  # is a faster approach according to freenode #mysql
  def self.find_by_tags(tag_ids)
    sql =  "SELECT * "
    sql << "FROM products "
    sql << "JOIN products_tags on products.id = products_tags.product_id "
    sql << "WHERE products_tags.tag_id IN (#{tag_ids.join(",")}) "
    sql << "GROUP BY products.id HAVING COUNT(*)=#{tag_ids.length} "
    find_by_sql(sql)
  end

  # Defined to save tags from product edit view
  def tags=(list)
    tags.clear
    for id in list
      tags << Tag.find(id) if !id.empty?
    end
  end
end
