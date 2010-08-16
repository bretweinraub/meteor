module Meteor
  module Helpers
    module ActionViewHelpers
      def render_meteor_widget(spec,h={})
        controller.render_meteor_widget(spec,h)
      end

      def render_meteor_widget_by_name(name,h={})
        controller.render_meteor_widget_by_name(name,h)
      end
    end
  end
end
