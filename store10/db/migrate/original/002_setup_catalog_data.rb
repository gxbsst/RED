class SetupCatalogData < ActiveRecord::Migration
  def self.up
    add_column    :tags, :sort_order, :integer

    Tag.new(:name => 'RED ONE CAMERA', :sort_order => '1').save
    Tag.new(:name => 'RED RAIL SYSTEMS', :sort_order => '2').save
    Tag.new(:name => 'POWER SYSTEMS', :sort_order => '3').save
    Tag.new(:name => 'MONITORING OPTIONS', :sort_order => '4').save
    Tag.new(:name => 'DIGITAL MEDIA OPTIONS', :sort_order => '5').save
    Tag.new(:name => 'P/L MOUNT LENSES', :sort_order => '6').save
    Tag.new(:name => 'OPTICAL ADAPTORS', :sort_order => '7').save
    Tag.new(:name => 'LENS ACCESSORIES', :sort_order => '8').save

    p = Product.new(:code=>'01-001',:name=>'RED ONE CAMERA',:price=>'17500',:date_available=>Date.today)
    p.tags.push(Tag.find_by_name('RED ONE CAMERA'))
    #p.images.push(Image.new(:id=>1,:path=>'redbase_side.png'))
    #p.images.push(Image.new(:id=>2,:path=>'redbase_angle.png'))
    p.save
  end

  def self.down
    remove_column :tags, :sort_order
    Product.delete_all
    Tag.delete_all
    Image.delete_all
  end
end
