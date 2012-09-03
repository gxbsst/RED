class ProductPackageNode < ActiveRecord::Base
  acts_as_list :scope => 'parent_id'
  belongs_to :parent_package, :foreign_key => 'parent_id', :class_name => "ProductPackage"
end