class AddContactPersonToAxAccount < ActiveRecord::Migration
  def self.up
    rename_column :ax_orders, :delivery_country, :delivery_county
    add_column :ax_accounts, :zip_code, :string, :null => false, :default => ""
    add_column :ax_accounts, :tele_prod_tax_exempt, :string, :null => false, :default => ""
    remove_column :ax_accounts, :contact_person_name
    remove_column :ax_accounts, :contact_person_select_address
    
    create_table :ax_account_contact_people do |t|
      t.column :ax_account_id,    :integer
      t.column :email,            :string, :null => false, :default => ""
      t.column :first_name,       :string, :null => false, :default => ""
      t.column :last_name,        :string, :null => false, :default => ""
      t.column :name,             :string, :null => false, :default => ""
      t.column :selected_address, :string, :null => false, :default => ""
    end
  end

  def self.down
    rename_column :ax_orders, :delivery_county, :delivery_country
    remove_column :ax_accounts, :zip_code
    remove_column :ax_accounts, :tele_prod_tax_exempt
    add_column :ax_accounts, :contact_person_name, :string
    add_column :ax_accounts, :contact_person_select_address, :string
    drop_table :ax_account_contact_people
  end
end
