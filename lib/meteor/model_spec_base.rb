module Meteor
  
  ################################################################################
  ################################################################################
  
  class ModelSpecBase < SpecBase

    #
    # controller_class : application controller that will receive CRUD events
    # 

    attr_accessor :controller_class

    #
    # klass : active record class object for records 
    # 

    attr_accessor :klass


    # for widgets that are linked to database objects

    def initialize(h={},&block)

      super(h,&block)

      _klass = self.klass.to_s.de_camelize

      self.name  = _klass unless h[:name]

      [:controller_class, :klass].each do |attr|
        raise "you must initialize a #{self.class} with a :#{attr} argument" unless
          self.send(attr)
      end

      self.title = "#{name}" unless title
      self.path  = path ? "#{path}.#{name}" : ".#{name}"

    end
  end
end

    
