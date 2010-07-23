require 'meteor'
require 'ruby-debug'

module Meteor
  
  ################################################################################
  ################################################################################
  
  class RendererBase < CkuruTools::HashInitializerClass

    #
    # :debug_exceptions : if set, exceptions will launch the debugger
    # 

    attr_accessor :debug_exceptions


    #
    # :frontend - where to look for partials.  Currently defaults to "meteor"
    # 

    attr_accessor :frontend

    #
    # All generated HTML element IDs will start with this prefix.  Defaults to 
    # "#{frontend}_#{spec.name}_#{id}" unless htmlprefix
    #

    attr_accessor :htmlprefix

    attr_accessor :id

    #
    # request params; allows rendering to be influenced by request parameters
    #

    attr_accessor :params

    #
    # For a widget rendered on an object, defined here.
    #
    
    attr_accessor :object

    #
    # :event : allows the default partial to be overriden (from  _render.rhtml)
    # 

    attr_accessor :event

    attr_accessor :sql

    attr_accessor :spec

    attr_accessor :controller # right not we are building in the assumption you are running from
                              # an ActionController::Base object (aka Rails).
    
    ################################################################################

    def controller_path
      controller.controller_path
    end

    ################################################################################

    def name
      spec.name
    end

    ################################################################################

    #
    # overrider this to change the search order of conditionally_render_partial()
    #

    def partial_search_order(partial)
      ["#{controller_path}/_#{frontend}_#{name.de_camelize}_#{partial}",
       "#{spec.controller_class.to_s.de_camelize}/_#{frontend}_#{name.de_camelize}_#{partial}",
       "#{controller_path}/_#{frontend}_#{partial}",
       "#{spec.controller_class.to_s.de_camelize}/_#{frontend}_#{partial}",
       "meteor/#{frontend}/_#{partial}",
       "meteor/default/_#{partial}"]
    end

    #
    # See the metor cookbook for discuss of the partial algorithm.
    # 

    def conditionally_render_partial(partial_spec, *args, &block)
      ret = nil
      partial_to_render = nil

      #
      # partial_spec can be an array of namespaces to search!
      #
      if partial_spec.is_a? Array
        partial_spec.each do |partial|
          break if partial_to_render = @template.partial_check_order(*partial_search_order(partial))
        end
      else
        partial_to_render = @template.partial_check_order(*partial_search_order(partial_spec))
      end

      if partial_to_render
        controller.instance_variable_set("@meteor_args", args[0])
#       http://www.omninerd.com/articles/render_to_string_in_Rails_Models_or_Rake_Tasks
#         Rails.cache.write(
#                           "cache_var", 
        render_hash = {
          :args => args[0],
          :renderer => self,
          :block => block
        }
        # this next block will make an instance variable (like htmlprefix) appear as a local in the partial
        # this has a net affect of creating a local in the partial for any non-nil attribute on this renderer
        #
        # thus a partial can just call 'object', for example.
        
        instance_variables.each do |iv|
          # iv = "@id"
          # renderer[:id] = self.id
          raise "uppercase param #{iv} passed to #{current_method}; this cannot be assigned to a local as this would be dynamically assigned a constant" if
            iv.match /^[A-Z]/
          render_hash[iv.gsub(/@/,'').to_sym] = instance_variable_get(iv)
        end

        # folds arguments to conditionally_render_partial into partial locals
        if args.length == 1 and args[0].is_a? Hash
          args[0].keys.each do |k|
            render_hash[k] = args[0][k]
          end
        else
          raise "unsupported call signature"
        end

        ret = @template.render(:partial => partial_to_render.gsub(/\/_/,"\/"), # ugly hack
                               :locals => render_hash)
      else
        # failsafe block
        if self.respond_to?("render_#{partial_spec}".to_sym)
          ret = send("render_#{partial_spec}",*args,&block) 
        else
          raise "nothing found to render for #{partial_spec}."
          ckebug 0, "nothing found to render for #{partial_spec}"
          ret = "no such partial #{partial_spec}" # hmmm....
        end
      end
      ret
    end
    

    ################################################################################

    def initialize(h={})
      begin
        @sqlcache = {}
#        self.debug_exceptions = true

        self.event = h[:event] || :render 

        super h      

        if object
          self.id = object.id
        end
        raise ":id (or :object), :spec, and :controller must be set in #{current_method}" unless 
          id and spec and controller
        raise ":controller is not of type ActionController::Base (#{controller.class} #{controller} instead)" unless 
          controller.is_a? ::ActionController::Base
        raise "cannot derive ActionView::Base template from controller" unless 
          @template = controller.instance_variable_get("@template")

        raise "set :frontend in #{current_method}" unless frontend

        # allows an array of partials to be checked for existence; return the first one found.
        def @template.partial_check_order(*args)
          #
          # ActionView#Base can have multiple view paths (I didn't know that when I first wrote this).
          # Ultimately I think Meteor should have used this feature instead of pushing its views into 
          # $RAILS_ROOT/app/views/meteor.
          #
          # TODO: break this dependency; allow for rails widget snippets to go anywhere.
          #

          view_paths.each do |view_path|
            args.each do |file_to_check|
              return file_to_check if (
                                       File.exists?("#{view_path}/#{file_to_check}.erb") or
                                       File.exists?("#{view_path}/#{file_to_check}.rhtml") 
                                       )
                                       

              

            end
          end
          nil
        end

        unless sql
          self.sql = self.respond_to?(:sql_query) ? self.send(:sql_query) : nil
        end
        self.htmlprefix = "#{frontend}_#{spec.name}_#{id}" unless htmlprefix

        #
        # If the spec has defined a callback to alter the renderer, call it.
        #
        spec.send(:after_renderer_initialize,self) if spec.respond_to?(:after_renderer_initialize)
        spec
      rescue Exception => e
        if debug_exceptions
          puts e
          debugger
        end
        raise e
      end
    end

    ################################################################################
    
    def render(h={})
      h.merge!(:htmlprefix => htmlprefix,
               :sql => sql,
               :name => name)
      
      begin
        conditionally_render_partial(event,h)  # event is set when the Renderer is created.
      rescue Exception => e
        if debug_exceptions
          puts e
          debugger
        end
        raise e
      end
    end
 
    ################################################################################

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

    ################################################################################

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

    ################################################################################

    def new_object(h={})
      klass = h[:klass]
      attributes = h[:attributes]
      newobj = klass.create(attributes)
      newobj.reload
      newobj
    end

    ################################################################################
    
    def do_crud(action,page,params)
      self.send("do_crud_#{action}",page,params)
    end

    ################################################################################

    def execute_block_with_error_div(page,error_div,indicator)
      begin
        yield
      rescue Exception => e
        error_msg = "#{e}"
        e.backtrace.each do |e|
          error_msg << "#{e}\n" if e.match(/(app|meteor)/)
        end
        if debug_exceptions
          puts error_msg
          debugger
        end

        puts error_msg
        
        page.hide indicator if indicator
        page.replace_html error_div, conditionally_render_partial(:error,{:error => error_msg, :div => error_div}) if error_div
        page.show error_div if error_div
      end
        
    end

    def data_for_render
      raise "no default behaviour for this"
    end

    ################################################################################
  end #   class Renderer < CkuruTools::HashInitializerClass
end
