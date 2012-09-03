class AddTwoNewSticker < ActiveRecord::Migration
  def self.up
    [
      Product.find_by_code("901007"),
      Product.find_by_code("901008")
    ].each do |sticker|
      if sticker
        sticker.update_attribute(:deposit, 0.0)
      end
    end
  end

  def self.down
    [
      Product.find_by_code("901007"),
      Product.find_by_code("901008")
    ].each do |sticker|
      if sticker
        sticker.update_attribute(:deposit, (sticker.price * 0.1))
      end
    end
  end
end
