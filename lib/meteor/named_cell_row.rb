module Meteor
  ################################################################################
  ################################################################################
  
  class NamedCellRow < CkuruTools::HashInitializerClass
    attr_accessor :cell_list

    attr_accessor :separator_row
    
    def initialize(h={},&block)
      self.separator_row = false
      self.cell_list = []
      super(h,&block)
      yield self if block_given?
    end
  end # class NamedCellRow
end

