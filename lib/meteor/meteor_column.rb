require 'meteor'

module Meteor
  class MeteorColumn < CkuruTools::HashInitializerClass

    #
    # In some cases you may want Meteor to completely ignore your column, like when
    # you've rendered some custom code for it yourself.
    #
    # Defaults to false
    #
    attr_accessor :ignore
    attr_accessor :name, :type, :refclass, :title, :create, :refsql, :edit


    # :select is a list of selections for a dropdown list

    attr_accessor :select
    attr_accessor :textbox_rows
    attr_accessor :textbox_columns

    #
    # For an m80 table it will be "#{refclass.table_name}_name"
    # To override this define a 'natural_key' method on the ActiveRecord class
    #
    # class MyClass <  ActiveRecord::Base
    #   def self.natural_key
    #     "natural key name"
    #   end
    # end

    attr_accessor :html_attributes

    attr_accessor :refclass_natural_key
    
    ################################################################################ 

    def initialize(h={})
      self.create = true
      self.edit = true
      self.ignore = false
      self.type = :scalar
      self.textbox_rows = 4
      self.textbox_columns = 80
      self.html_attributes = {}
      super h      
      yield self if block_given?

      raise ":refclass must be defined for type :ref" if self.type == :ref and not self.refclass

      if type == :ref
        unless refclass_natural_key
          if refclass.respond_to?(:natural_key)
            self.refclass_natural_key = refclass.send(:natural_key)
          else
            #m80 hard code
            # two ways to override this.
            # 1. assign refclass_natural_key on Meteor::Column.new(:refclass_natural_key => ...)
            # 2. define ':natural_key' method on your model
            self.refclass_natural_key = "#{refclass.table_name}_name"
          end
        end
      end
      raise "set :name" unless name
    end
    
    ################################################################################ 

    def render_column_header(renderer,args)
      renderer.conditionally_render_partial(:column_header,     
                                            args.merge(:column => self))
    end
    
    ################################################################################ 

    def finder_sql(h={})
      column = h[:column]
      
      column.refsql ? column.refsql : "select * from #{column.refclass.table_name} order by #{refclass_natural_key}"
    end
  end
  
  ################################################################################
  ################################################################################
end
