class AddContactTicketLogs < ActiveRecord::Migration
  def self.up
    create_table 'contact_tickets' do |t|
      t.column 'post_data', :text
      t.column 'is_completed', :boolean, :default => false
      t.column 'created_at', :datetime, :null => false
    end
    
    create_table 'contact_ticket_logs' do |t|
      t.column 'contact_ticket_id', :integer, :null => false
      t.column 'message', :text
      t.column 'response_body', :text
      t.column 'response_code', :string, :size => 10
      t.column 'created_at', :datetime, :null => false
    end
  end
  
  def self.down
    drop_table 'contact_tickets'
    drop_table 'contact_ticket_logs'
  end
end