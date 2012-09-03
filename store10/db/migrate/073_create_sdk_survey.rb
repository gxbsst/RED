class CreateSdkSurvey < ActiveRecord::Migration
  def self.up
    create_table :sdk_surveys, :force => true do |t|
      t.column :first_name,           :string
      t.column :last_name,            :string
      t.column :company,              :string
      t.column :address1,             :string
      t.column :address2,             :string
      t.column :city,                 :string
      t.column :state,                :string
      t.column :zip_code,             :string
      t.column :country,              :string
      t.column :email,                :string
      t.column :product_name,         :string
      t.column :project_description,  :text
      t.column :phone,                :string
      t.column :mac,                  :boolean, :default => false
      t.column :windows,              :boolean, :default => false
      t.column :fax,                  :string
      t.column :remote_ip,            :string
      t.column :send_mailed,          :boolean, :default => false
      t.column :created_at,           :datetime
      t.column :updated_at,           :datetime
    end
  end

  def self.down
    drop_table :sdk_surveys
  end
end
