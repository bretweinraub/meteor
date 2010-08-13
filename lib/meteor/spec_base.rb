module Meteor
  
  ################################################################################
  ################################################################################
  
  class SpecBase < CkuruTools::HashInitializerClass
    #
    # children : these are embedded meteors (meteorites).  
    #

    attr_accessor :children

    #
    # This is default frontend to render a widget of this. Defaults to a the de_camelized name of the klass.
    # 
    
    attr_accessor :default_frontend

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
        s.controller_class = controller_class if self.respond_to? :controller_class
        s.parent = self
        yield s if block_given?
      end
      children.push child
      child
    end

    ################################################################################
    
    def initialize(h={},&block)
      self.children = []

      super(h,&block)

      _klass = self.class.to_s.de_camelize
      _klass = self.class.parent.to_s.split(/::/).last.de_camelize

      self.name  = _klass unless name
      self.default_frontend  = _klass unless default_frontend
      self.title = "#{name}" unless title
      self.path  = path ? "#{path}.#{name}" : ".#{name}"
    end
    
    ################################################################################
  end #   class Spec < CkuruTools::HashInitializerClass
end
