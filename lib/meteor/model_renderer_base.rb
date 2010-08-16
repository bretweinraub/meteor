module Meteor
  class ModelRendererBase < RendererBase
    # Id of model instance to associate with.
    attr_accessor :id

    # For a widget rendered on an object, defined here.
    attr_accessor :object

    attr_accessor :sql

    def initialize(h={})
      begin
        super h

        @sqlcache = {}
        if object
          self.id = object.id
        end
        raise ":id must be set in #{current_method}" unless id

        unless sql
          self.sql = self.respond_to?(:sql_query) ? self.send(:sql_query) : nil
        end

      rescue Exception => e
        if debug_exceptions
          puts e
          debugger
        end
        raise e
      end
    end

    def render(h={})
      h.merge!(:sql => sql)
      super h
    end

    def render_child(h={},extras={})
      child=h[:child]
      row=h[:row]
      child_class = child.class.renderer_class

      renderer = child_class.new(:spec => child,
                                 :controller => controller,
                                 :frontend => frontend,
                                 :event => event,
                                 :params => params,
                                 :id => row.id)
      renderer.render(extras)
    end

    def caching_finder(h={})
      raise "set :klass and :sql in #{current_method}" unless
        klass = h[:klass] and sql = h[:sql]

      @sqlcache[:klass] = {} unless @sqlcache[:klass]

      if @sqlcache[:klass][sql]
        ckebug 0, "using cached version of #{sql}"
        @sqlcache[:klass][sql]
      else
        ckebug 0, "no cached version for #{sql}"
        @sqlcache[:klass][sql] = klass.send(:find_by_sql,sql)
      end
    end

    def new_object(h={})
      klass = h[:klass]
      attributes = h[:attributes]
      newobj = klass.create(attributes)
      newobj.reload
      newobj
    end

    def do_crud(action,page,params)
      self.send("do_crud_#{action}",page,params)
    end
  end
end
