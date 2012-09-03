class CreateChinaEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.column :name,        :string, :null => false, :default => ""
      t.column :description, :text
    end
    
    create_table :participants do |t|
      t.column :event_id,           :integer
      t.column :name,               :string
      t.column :email,              :string
      t.column :province,           :string
      t.column :city,               :string
      t.column :company_name,       :string
      t.column :company_website,    :string
      t.column :created_at,         :datetime
      t.column :address,            :string
      t.column :mobile_phone,       :string
      t.column :fixed_phone,        :string
      t.column :reason,             :text
      t.column :participanter_name, :text
      t.column :available_time,     :text
      t.column :camera_type_using,  :string
      t.column :scope_of_business,  :string
      t.column :post_code,          :string
      t.column :serial_number,      :string
      t.column :deleted,            :boolean, :null => false, :default => true
    end
  end

  def self.down
    drop_table :participants
    drop_table :events
  end
end