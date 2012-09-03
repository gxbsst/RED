class RedUserAccount < ActiveRecord::Migration
  def self.up
    # Images/Products...
    add_column :images_products, :sort_order, :integer

    # Add an Account Balance equal to Sum ( all payments )
    add_column    :order_users, :updated_on, :datetime
    add_column    :order_users, :confirm_email, :string
    add_column    :order_users, :confirm_password, :string
    add_column    :order_users, :name, :string
    add_column    :order_users, :company, :string
    remove_column :order_users, :username

    # Add the Shipping Label and Company information to the address...
    add_column    :order_addresses, :created_on, :datetime
    add_column    :order_addresses, :updated_on, :datetime
    add_column    :order_addresses, :shipping_label, :text
    add_column    :order_addresses, :company, :string
    add_column    :order_addresses, :name, :string
    add_column    :order_addresses, :address_two, :string
    remove_column :order_addresses, :first_name
    remove_column :order_addresses, :last_name

    # Allow multiple users to be CC'd on the Order Status of this account
    create_table :order_users_emails,  :force => true do |t|
      t.column "order_users_id", :integer, :default => 0, :null => false
      t.column "real_name", :string, :limit => 50, :default => "", :null => false
      t.column "email", :string, :limit => 50, :default => "", :null => false
    end

    # Reservations...
    create_table :reservations do |t|
      t.column "email_address", :string
      t.column "secret_code", :string
      t.column "order_id", :integer
      t.column "total", :float
      t.column "name", :string
      t.column "payment_method", :string
      t.column "source_name", :string
      t.column "source_id", :string
      t.column "paid_on", :datetime
    end

    create_table :reservation_items do |t|
      t.column "reservation_id", :integer
      t.column "serial_number", :string
      t.column "description", :string
      t.column "price", :float
    end
  end

  def self.down
    drop_table    :reservations
    drop_table    :reservation_items
    
    # image_products
    remove_column :images_products, :sort_order

    # order_users
    remove_column :order_users, :confirm_email
    remove_column :order_users, :confirm_password
    remove_column :order_users, :updated_on
    remove_column :order_users, :name
    remove_column :order_users, :company
    add_column    :order_users, :username, :string

    # order_addresses
    remove_column :order_addresses, :updated_on
    remove_column :order_addresses, :created_on
    remove_column :order_addresses, :shipping_label
    remove_column :order_addresses, :company
    remove_column :order_addresses, :name
    remove_column :order_addresses, :address_two
    add_column    :order_addresses, :first_name, :string
    add_column    :order_addresses, :last_name, :string

    # order_users_emails
    drop_table    :order_users_emails
  end
end
