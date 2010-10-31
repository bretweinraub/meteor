module Meteor
  module Widget
    module <%= class_name %>
      # You've generated a new Meteor Widget!
      #
      # Your new widget can be rendered with the following:
      #
      # <%%= render_meteor_widget(::Meteor::Widget::<%= class_name %>::Spec.new(...) -%>
      #   
      # This renders its partial, vendor/plugins/<%= file_name %>/templates/<%= file_name %>/_render.rhtml.
      #
      # In your partial you can get a hold of your spec object with a local call 'spec'.

      class Spec < ::Meteor::PluginSpecBase

        include MeteorWidgetPlugin

        def initialize(options={},&block)
          super(options,&block)
        end
      end
    end
  end
end
