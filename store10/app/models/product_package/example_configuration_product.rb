class ExampleConfigurationProduct < ActiveRecord::Base
  belongs_to :example_configuration
  belongs_to :product
end