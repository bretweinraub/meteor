module Meteor
  class Util

    def self.controller_to_url s
      # http://www.ruby-forum.com/topic/113697 
      s.respond_to?(:to_s) ? s.to_s.gsub(/Controller$/,'').de_camelize : nil
    end

    ################################################################################
    
    def self.js_code_block(arr)
      ret = ""
      arr.each do |a|
        ret += "#{a};"
      end
      ret
    end
    
  end # class Meteor::Util
end
