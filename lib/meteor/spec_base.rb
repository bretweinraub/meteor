module Meteor
  
  ################################################################################
  ################################################################################
  
  class SpecBase
    #
    # children : these are embedded meteors (meteorites).  
    #

    attr_accessor :children
    
    #
    # controller_class : application controller that will receive CRUD events
    # 

    attr_accessor :controller_class

    #
    # klass : active record class object for records 
    # 

    attr_accessor :klass

    #
    # name : unique name for this meteor object.  Defaults to a the de_camelized name of the klass.
    #

    attr_accessor :name

    # path: use to generate HTML "id" paths to this element; used primarily for meteorites.

    attr_accessor :path

    # parent: a reference to a parent spec if any.  Enforced by the add_child() method.
    
    attr_accessor :parent

    #
    # title: used to generate the HTML visible title for this meteor widget.
    #

    attr_accessor :title

    ################################################################################

    def renderer_class
      raise "you must define the renderer class that will render this spec"
    end

    def self.find_by_path(h={})
      raise "set :spec and :path in #{current_method}; args are #{h.inspect}" unless spec = h[:spec] and path = h[:path]

      ret = nil
      if spec.path == path
        ret = spec
      else
        spec.children.each do |child|
          break if ret = SpecBase.find_by_path(:spec => child,
                                               :path => path)
        end
      end
      ret
    end

    ################################################################################

    def add_child(h={})
      child = Spec.new do |s|
        s.path = path
        s.controller_class = controller_class
        s.parent = self
        yield s if block_given?
      end
      children.push child
      child
    end

    ################################################################################
    
    def initialize(h={})
      self.children = []

      yield self if block_given?

      [:controller_class, :klass].each do |attr|
        raise "you must initialize a #{self.class} with a :#{attr} argument" unless
          self.send(attr)
      end

      self.name  = self.klass.to_s.de_camelize unless name
      self.title = "#{name}" unless title
      self.path  = path ? "#{path}.#{name}" : ".#{name}"
    end
    
    ################################################################################
  end #   class Spec < CkuruTools::HashInitializerClass
end
