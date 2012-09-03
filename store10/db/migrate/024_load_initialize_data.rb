class LoadInitializeData < ActiveRecord::Migration
  def self.up
    require 'active_record/fixtures'
    ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
    fixtures = [
      "images.yml",
      "roles.yml",
      "images_products.yml",
      "order_status_codes.yml",
      "tags.yml",
      "rights.yml",
      "order_shipping_types.yml",
      "engine_schema_info.yml",
      "users.yml",
      "content_nodes.yml",
      "products.yml",
      "content_node_types.yml",
      "rights_roles.yml",
      "roles_users.yml",
      "news_admin_users.yml",
      "countries.yml",
      "news.yml",
      "products_tags.yml"
      ].each do |fixture|
      Fixtures.create_fixtures(File.dirname(__FILE__)+"/dev_data", File.basename(fixture, '.*'))
    end
  end

  def self.down
  end
end
