

desc "sync data to products accord with axobj and erp items"
namespace :erp do
  task :sync_products => :environment do
    ERP::Item.sync_erp_item_and_products
  end
end