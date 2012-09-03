module MailTasksW1
	class Task < ActiveRecord::Base
		include MailTasksW1::Base
		# Associations
		has_many :mails
		belongs_to :template

		def generate_mails( contacts, do_save_mail = true, layout_options={} )
			self.class.transaction do
				contacts.each do |contact|
					mail = self.mails.build(
					:email => contact.email,
					:first_name => contact.first_name,
					:last_name => contact.last_name,
					:company_name => contact.company_name,
					:account_num => contact.account_num,
					:sales_id => contact.sales_id,
					:token => contact.token,
					:content => contact.content,
					:rep_email => contact.rep_email,
					:created_at => contact.created_at,
					:updated_at => contact.updated_at,
					:read_at => contact.read_at,
					:sent_at => contact.sent_at,
					:name => contact.name
					)
					mail.save! if do_save_mail
				end
			end
		end
		
	end
end