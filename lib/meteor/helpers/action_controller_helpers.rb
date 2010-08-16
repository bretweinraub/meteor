module Meteor
  module Helpers
    module ActionControllerHelpers
      ################################################################################
      def render_meteor_widget_by_name(name,h={})
        render_meteor_widget(meteor_spec(name),h)
      end

      ################################################################################
      def render_meteor_widget(spec,h={})
        call_args = {
          :controller => self,
          :params => request.params
        }
        spec.render(call_args.merge!(h))
      end
      ################################################################################
    end
  end
end
