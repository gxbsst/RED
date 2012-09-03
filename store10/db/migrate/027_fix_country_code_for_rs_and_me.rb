class FixCountryCodeForRsAndMe < ActiveRecord::Migration
  def self.up
    execute "update countries set fedex_code = 'RS',name = 'Serbia' where fedex_code = 'CS'"
    execute "insert into countries (name,fedex_code) values('Montenegro','ME')"
  end

  def self.down
    execute "update countries set fedex_code = 'CS',name = 'Serbia (Montenegro)' where fedex_code ='RS'"
    execute "delete from countries where fedex_code = 'ME'"
  end
end
