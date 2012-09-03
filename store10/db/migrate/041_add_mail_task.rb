class AddMailTask < ActiveRecord::Migration
  def self.up
    create_table :redone_serial_numbers, :force => true do |t|
      t.column :ax_account_number,    :string
      t.column :ax_account_id,        :integer
      t.column :ax_order_number,      :string
      t.column :ax_order_id,          :integer
      t.column :email_address,        :string
      t.column :first_name,           :string
      t.column :last_name,            :string
      t.column :serial_number,        :string
      t.column :purch_order_form_num, :string
      t.column :sent_mail,            :boolean, :default => false
      t.column :created_at,           :datetime
      t.column :updated_at,           :datetime
    end
    
    Right.create(:name => 'MailTasks', :controller => 'mail_tasks', :actions => '*')
    Role.find(1).rights << Right.find_by_controller('mail_tasks')
  end

  def self.down
    drop_table :redone_serial_numbers
    
    Role.find(1).rights.delete(Right.find_by_controller('mail_tasks'))
    Right.find_by_controller('mail_tasks').destroy
  end
end
