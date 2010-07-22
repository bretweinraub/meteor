# Include hook code here

require 'rubygems'
require 'ckuru-tools'

Dir.glob(File.expand_path(File.join(File.dirname(__FILE__),'lib','**','*.rb'))).each {|rb| 
  require rb
}

require File.join(File.dirname(__FILE__),'lib','extensions.rb')
