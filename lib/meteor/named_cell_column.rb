module Meteor
  ################################################################################
  ################################################################################
  class NamedCellColumn < CkuruTools::HashInitializerClass
    #
    # In some cases you may want Meteor to completely ignore your column, like when
    # you've rendered some custom code for it yourself.
    #
    # Defaults to false
    #
    attr_accessor :ignore
    
    attr_accessor :refclass
    
    attr_accessor :name, :type, :title, :create, :refsql, :edit
    attr_accessor :colspan

    ################################################################################
    
    def title
      t = self.instance_variable_get("@title")
      t ? t : name.to_s.gsub(/_/,' ').capitalize
    end

    ################################################################################
    
    def initialize(h={})
      self.create = true
      self.edit = true
      self.ignore = false
      self.type = :scalar
      super h      
      yield self if block_given?
      raise "set :name in #{current_method}" unless name
    end
    
    ################################################################################
    
    def render_column_header(renderer,args)
      renderer.conditionally_render_partial(:column_header,     
                                            args.merge(:column => self))
    end
    
  end
  
end
