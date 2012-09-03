class AgreementLog < ActiveRecord::Base
  belongs_to :agreement, :class_name => 'AgreementVersion'
  belongs_to :store_user
  belongs_to :order
  belongs_to :download
  
  def store_user=(store_user)
    return unless store_user && store_user.is_a?(StoreUser)
    
    self[:store_user_id] = store_user.id
    self[:name] = store_user.name
    self[:email_address] = store_user.email_address
  end

  def remote_ip=(ip)
    return if ip.blank?
    
    self[:remote_ip] = ip
    begin
      self[:remote_location] = Ip2address.find_location(ip)
    rescue
      self[:remote_location] = "-,-,-"
    end
  end
  

  def order=(order)
    return unless order && order.is_a?(Order)
    
    self[:order_id] = order.id
    self[:order_number] = order.order_number
  end

  def agreement=(agreement_version)
    return unless agreement_version && agreement_version.is_a?(AgreementVersion)
    
    self[:agreement_version_id] = agreement_version.id
    self[:agreement_name] = agreement_version.agreement.name
    self[:agreement_version] = agreement_version.version
  end

  def download=(download_version)
    return unless download_version && download_version.is_a?(Download)
    
    self[:download_id] = download_version.id
    self[:download_name] = download_version.download_category.title
    self[:download_version] = download_version.version
  end

end