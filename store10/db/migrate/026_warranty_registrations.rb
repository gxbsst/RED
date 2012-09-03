class WarrantyRegistrations < ActiveRecord::Migration
  def self.up
    create_table "warranty_registrations" do |t|
      t.column :first_name, :string
      t.column :last_name, :string
      t.column :company, :string
      t.column :product_categories, :string
      t.column :product, :string
      t.column :serial_number,:integer,:limit => 100
      t.column :address1, :string
      t.column :address2, :string
      t.column :city ,:string
      t.column :state, :string
      t.column :zip, :integer, :limit => 10
      t.column :country ,:string
      t.column :phone_number, :string 
      t.column :email_address, :string
    end
  end

  def self.down
    drop_table "warranty_registrations"              
  end
end
