module Meteor
  module Widget
    module <%= class_name %>
      module MeteorWidgetPlugin
        def plugin_name
          # XXX - I assume this will break down under heavy load; then name of the plugin this widget is found in.
          # This helps determine the render path for the template.
          File.dirname(__FILE__).split(/\//).last
        end
      end
    end
  end
end

