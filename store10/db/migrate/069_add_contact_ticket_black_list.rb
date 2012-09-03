class AddContactTicketBlackList < ActiveRecord::Migration
  def self.up
    create_table 'contact_ticket_black_lists' do |t|
      t.column 'email', :string
    end

    ['manvirtue@aol.com', 'tortoisespecs@yahoo.com', 'oakleyboycott@gmail.com', 'luxotticashareholderadvocacy@yahoo.com', 'luxotticadeaththreats@gmail.com', 'osapricefixingcartel@gmail.com', 'oliverpeoplesmadeinchina@gmail.com','seanmichaelmcwilliams0311@gmail.com'].each do |i|
      ContactTicketBlackList.create(:email => i)
    end
 
  end

  def self.down
    drop_table :contact_ticket_black_lists
  end
end
