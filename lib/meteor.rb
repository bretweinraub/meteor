require 'meteor_helper'

Dir[File.dirname(__FILE__) + '/meteor/*.rb'].each do |file|
  require file
end

module Meteor
end

require 'init'
