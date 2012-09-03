class AddProductPackage < ActiveRecord::Migration
  def self.up
    # Product Package Nodes
    create_table :product_package_nodes do |t|
      t.column :type, :string, :null => false
      t.column :parent_id, :integer
      t.column :product_id, :integer
      t.column :name, :string
      t.column :description, :text
      t.column :position, :integer
      t.column :created_at, :datetime
      t.column :additional_html, :text
      t.column :display_style, :string, :limit => "20"
    end
    add_index 'product_package_nodes', 'parent_id'
    
    # Example Configuration
    create_table 'example_configurations' do |t|
      t.column 'name', :string
      t.column 'description', :text
      t.column 'position', :integer
    end
    
    create_table 'example_configuration_products' do |t|
      t.column 'example_configuration_id', :integer, :null => false
      t.column 'product_id', :integer
      t.column 'quantity', :integer
    end
    
    # Administrator rights
    right = Right.create :controller => "product_packages", :actions => "*", :name => "Product Package - Admin"
    Role.find(1).rights << right
  end
  
  def self.down
    drop_table 'product_package_nodes'
    drop_table 'example_configurations'
    drop_table 'example_configuration_products'
  end
end