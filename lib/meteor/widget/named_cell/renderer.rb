module Meteor
  module Widget
    module NamedCell
      class Renderer < ModelRendererBase
        # deprecated; use data_for_render()
        def object
          ckebug 0, "Deprecated; use data_for_render()"
          if val = instance_variable_get("@object")
            val
          else
            # load object if it hasn't been loaded yet
            self.object = spec.klass.find(id)
          end
        end
      end
    end
  end
end
