class AdditionMoreDetialToAgreementLog < ActiveRecord::Migration
  def self.up
    add_column :agreement_logs, :http_header,       :text
    add_column :agreement_logs, :name,              :string
    add_column :agreement_logs, :email_address,     :string
    add_column :agreement_logs, :order_number,      :string
    add_column :agreement_logs, :remote_location,   :string
    add_column :agreement_logs, :agreement_name,    :string
    add_column :agreement_logs, :agreement_version, :string
    add_column :agreement_logs, :download_name,     :string
    add_column :agreement_logs, :download_version,  :string

    # Update all exist records.
    AgreementLog.find(:all).each do |log|
      log.update_attributes(
        :agreement  => log.agreement,
        :store_user => log.store_user,
        :order      => log.order.blank? ? nil : log.order,
        :download   => log.download.blank? ? nil : log.download,
        :remote_ip  => log.remote_ip
      )
    end
  end

  def self.down
    remove_column :agreement_logs, :http_header
    remove_column :agreement_logs, :name
    remove_column :agreement_logs, :email_address
    remove_column :agreement_logs, :order_number
    remove_column :agreement_logs, :remote_location
    remove_column :agreement_logs, :agreement_name
    remove_column :agreement_logs, :agreement_version
    remove_column :agreement_logs, :download_name
    remove_column :agreement_logs, :download_version
  end
end
