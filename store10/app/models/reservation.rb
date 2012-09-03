class Reservation < ActiveRecord::Base
  has_many :reservation_items,
  	:dependent => :destroy

  def validate
    # Make sure the Reservation has NOT already been claimed
  end
end
