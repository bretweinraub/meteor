module Meteor
  module Widget
    module NamedCell
      class Row < CkuruTools::HashInitializerClass
        attr_accessor :cell_list
        attr_accessor :separator_row

        def initialize(h={},&block)
          self.separator_row = false
          self.cell_list = []
          super(h, &block)
        end
      end
    end
  end
end
