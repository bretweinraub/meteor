# Include hook code here

require 'rubygems'
require 'ckuru-tools'

rec=0
while rec < 2 do
  Dir.glob(File.expand_path(File.join(File.dirname(__FILE__),'lib','**','*.rb'))).each {|rb|
    begin
      require rb
    rescue Exception => e
      if rec > 0
        raise e
      end
    end
  }
  rec += 1
end

require File.join(File.dirname(__FILE__),'extensions.rb')

ActionView::Base.send :include, MeteorHelper
