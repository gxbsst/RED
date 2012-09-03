class CreateContactTickets < ActiveRecord::Migration
  def self.up
    create_table :tickets do |t|
      %W{name email phone serial_numbers}.each do |column|
        t.column column, :string, :limit => 64
      end
      %W{subject url user_agent user_screen}.each do |column|
        t.column column, :string
      end
      t.column 'product_type', :string, :limit => 16
      t.column 'queue', :string, :limit => 16
      t.column  'lang', :string, :limit => 16
      t.column 'content', :text
      
      # columns for ticket status
      t.column 'uuid', :string, :limit => 36, :null => false
      t.column 'submitted', :boolean, :null => false, :default => false
      t.column 'created_at', :datetime
      t.column 'updated_at', :datetime
    end
    
    %W{email submitted uuid}.each { |column| add_index :tickets, column }
  end

  def self.down
    drop_table :tickets
  end
end
