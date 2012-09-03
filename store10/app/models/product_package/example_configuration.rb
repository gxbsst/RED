class ExampleConfiguration < ActiveRecord::Base
  has_many :example_configuration_products, :include => :product
end