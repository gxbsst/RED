class SdkSurvey < ActiveRecord::Base
  #Validation
  # validates_presence_of  :email
  # validates_uniqueness_of :email, :on => :create, :message => 'The email has already been taken!'
  # def before_create
  #    self.sid =  UUID.random_create.to_s.gsub(/-/,'')
  #  end
  #  
  #  def expire_time
  #    # expire date is 30 days after mail sent.
  #    # updated_at.advance(:days => 30)
  #    # expire date is half-hour after mail sent.
  #    updated_at.since(1800)
  #  end
  #  
  #  def expire_date
  #    expire_time.strftime('%Y-%m-%d')
  #  end
  #  
  #  def expired?
  #    Time.now >= expire_time
  #    # true
  #  end
   
end
