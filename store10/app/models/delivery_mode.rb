class DeliveryMode < ActiveRecord::Base
  DELIVERY_MODE_MAP = self.find(:all).inject({}){|sum,i|sum.merge!(i[:code] => i[:description])}
end
