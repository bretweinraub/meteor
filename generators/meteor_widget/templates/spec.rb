module Meteor
  module Widget
    module <%= class_name %>
      # The simplest meteor widget for demonstration purposes.
      #
      # Creates a new <h1/> elements containing text specified.
      #
      # Can be rendered with the following:
      #
      # <%%= render_meteor_widget(::Meteor::Widget::<%= class_name %>::Spec.new(...) -%>
      #   
      # Hits its partial, app/views/meteor/<%= file_name %>/_render.rhtml.

      class Spec < ::Meteor::SpecBase
        def initialize(options={},&block)
          super(options,&block)
        end
      end
    end
  end
end
