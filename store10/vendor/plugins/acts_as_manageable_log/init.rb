=begin
require 'manageable_logs'
require 'acts_as_manageable_log'

ActiveRecord::Base.send( :include, Hozaka::Acts::ManageableLog::Base )
=end