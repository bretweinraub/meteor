module Meteor
  class MeteorSpec < ::Meteor::SpecBase

    # if true, the user can delete the record

    attr_accessor :delete

    
    #
    # columns : column descriptors.
    #

    
    attr_accessor :columns

    #
    # parent_klass : in an active record belongs_to association, parent class is
    # the class that this editor "belongs_to".  Right now required but should probably
    # be optional.
    #

    attr_accessor :parent_klass

    #
    # retain_addform_after_add: setting to true keeps the addform from being hidden after an add operation.
    # 

    attr_accessor :retain_addform_after_add


    ################################################################################
    
    def self.renderer_class
      ::Meteor::MeteorRenderer
    end

    ################################################################################

    def non_ignored_columns
      columns.select {|x| ! x.ignore}
    end
    
    ################################################################################

    def create_columns
      ret = []
      non_ignored_columns.each do |col|
        ret.push col if col.create
      end
      ret
    end

    ################################################################################

    def edit_columns
      ret = []
      non_ignored_columns.each do |col|
        ret.push col if col.edit
      end
      ret
    end
    
    ################################################################################

    def number_create_columns
      create_columns.length
    end
    ################################################################################

    def number_edit_columns
      edit_columns.length
    end
    
    ################################################################################

    def has_children?
      children.length > 0
    end

    ################################################################################

    def ok_to_add?
      create_columns.length > 0
    end

    ################################################################################

    def ok_to_edit?
      edit_columns.length > 0
    end

    def ok_to_delete?
      delete
    end
      

    ################################################################################

    def ok_to_upload?
      non_ignored_columns.each do |col|
        if col.type == :file
          return true
        end
      end
      return false
    end

    ################################################################################

    def add_child(h={})
      child = MeteorSpec.new do |s|
        s.parent_klass = klass
        s.path = path
        s.controller_class = controller_class
        s.parent = self
        yield s if block_given?
      end
      children.push child
      child
    end

    ################################################################################

    def initialize(*args,&block)
      self.columns = []
      self.retain_addform_after_add = false
      self.delete = false

      super(*args,&block)
    end

  end # class MeteorSpec

  ################################################################################
  ################################################################################
end # module  Meteor
