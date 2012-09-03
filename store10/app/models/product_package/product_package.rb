class ProductPackage < ProductPackageNode
  
  has_many :product_package_nodes, :foreign_key => 'parent_id', :order => "position" do
    # Implement a method instead of original "<<"
    # Append item(s) which is an instance of ProductPackItem
    #   (including ProductPack and ProductPackProduct) or original Product.
    def append(items)
      ProductPackItem.transaction do
        items.each do |item|
          if item.is_a?(ProductPackItem)
            # Append a product pack or product item.
            self << item
          elsif item.is_a?(Product)
            # Appending a product in this association.
            self << ProductPackProduct.new(:product => item)
          else
            # Raise an exception if invalid object is given.
            raise "ProductPackItem or Product expected, got #{item.class.name}"
          end
        end
      end
    end
  end

=begin  
  has_and_belongs_to_many :products,
    :join_table => 'product_pack_items', :foreign_key => 'parent_id', :association_foreign_key => 'product_id',
    :insert_sql => 'INSERT INTO product_pack_items (parent_id, product_id) VALUES (#{id}, #{record.id})',
    :order => 'position'
  
  has_and_belongs_to_many :packs,
    :class_name => 'ProductPack',
    :join_table => 'product_pack_items', :foreign_key => 'parent_id', :association_foreign_key => 'product_pack_id',
    :insert_sql => 'INSERT INTO product_pack_items (parent_id, product_pack_id) VALUES (#{id}, #{record.id})',
    :order => 'position'
  
  has_many :items, :class_name => 'ProductPackItem', :foreign_key => 'parent_id', :order => 'position'
  
  def self.load_top_packs
    find(
      :all,
      :include => :products,
      :joins => 'LEFT OUTER JOIN product_pack_items top_packs ON top_packs.product_pack_id = product_packs.id AND top_packs.parent_id IS NULL',
      :order => 'product_pack_items.position'
    )
  end
=end

end