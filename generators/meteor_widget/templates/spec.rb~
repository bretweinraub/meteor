module Widget
  module Header
    # The simplest meteor widget for demonstration purposes.
    #
    # Creates a new <h1/> elements containing text specified.
    #
    # Can be rendered with the following:
    #
    # <%= render_meteor_widget(::Widget::Header::Spec.new('Show/Edit Genre')) -%>
    #
    #
    #   
    # Hits its partial, app/views/meteor/header/_render.rhtml.

    class Spec < ::Meteor::SpecBase
      attr_accessor :text
      def initialize(text, options={},&block)
        @text = text
        super(options,&block)
      end
    end
  end
end
