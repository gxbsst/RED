class ProductShippingRate < ActiveRecord::Base
  # cache all rates record in memory
  FEDEX_SHIPPING_RATES = self.find(:all).map(&:attributes)
  
  # fedex code and available mode of this code mapping
  FEDEX_ZONE_MODE_MAP = FEDEX_SHIPPING_RATES.group_by{|rate|rate['shipping_zone']}.map do |shipping_zone, shipping_rates|
    {shipping_zone => shipping_rates.map {|rate| rate['code']}.uniq!}
  end.inject({}) {|sum,i| sum.merge!(i)}
  
  class << self
    require 'ostruct'
    def fedex_shipping_options(fedex_zone, shipping_points)
      return [] if fedex_zone.blank?
      return [] if FEDEX_ZONE_MODE_MAP[fedex_zone].nil?
      
      # split shipping points to divided point and construct to arra
      points = split_shipping_points(ErpHelper.roundf(shipping_points, 1))
      
      FEDEX_ZONE_MODE_MAP[fedex_zone].map do |shipping_mode|
        OpenStruct.new({
            :shipping_charge => points.inject(0.0) {|sum, shipping_point| sum + find_fedex_retail_price(fedex_zone, shipping_mode, shipping_point)},
            :delivery_mode   => shipping_mode,
            :description     => DeliveryMode::DELIVERY_MODE_MAP[shipping_mode]
          })
      end.sort_by {|opt| opt.shipping_charge}
    end
    
    # split shipping points to divided point and construct to array
    def split_shipping_points(shipping_points, division=100)
      return [shipping_points] if shipping_points <= division
      
      result = [] << (shipping_points % division)
      result.concat Array.new((shipping_points - shipping_points % division)/division, division)
      return result
    end
    
    # find retail price for fedex
    # may be more express vendro here in the future
    def find_fedex_retail_price(fedex_zone, shipping_mode, shipping_point)
      price = FEDEX_SHIPPING_RATES.find {|rate| rate['shipping_zone'] == fedex_zone && rate['code'] == shipping_mode && rate['min_points'] <= shipping_point && rate['max_points'] >= shipping_point }
      price.nil? ? 0.0 : price['retail_price']
    end
  end
  
  def description
    desc = DeliveryMode::DELIVERY_MODE_MAP[code]
    desc.blank? ? '' : desc
  end
end
