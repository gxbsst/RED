namespace :contact do
  desc "Re-post failed tickets to RT server."
  task :repost => :environment do
    tickets = ContactTicket.find :all, :conditions => ['is_completed = ?', false]
    puts "[INFO] #{tickets.size} tickets loaded in queue ..."
    
    # Post all tickets
    tickets.each do |ticket|
      fields = {}
      CGIMethods.parse_query_parameters(ticket.post_data).each do |key, value|
        fields.merge! key.to_sym => value
      end
      
      ticket.fields = fields
      if ticket.post
        puts "[OK] Ticket \"#{ticket.fields[:summary]}\" posted"
        log.update_attribute 'posted_at', Time.now
      else
        puts "[ERROR] Ticket \"#{ticket.fields[:summary]}\" posted failed!"
      end
    end
  end
end