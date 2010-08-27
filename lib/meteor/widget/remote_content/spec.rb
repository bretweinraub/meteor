module Meteor
  module Widget
    module RemoteContent
      # You've generated a new Meteor Widget!
      #
      # Your new widget can be rendered with the following:
      #
      # <%= render_meteor_widget(::Meteor::Widget::RemoteContent::Spec.new(...) -%>
      #   
      # This renders its partial, app/views/meteor/remote_content/_render.rhtml.
      #
      # In your partial you can get a hold of your spec object with a local cal

      class Spec < ::Meteor::SpecBase

        def self.renderer_class
          ::Meteor::Widget::RemoteContent::Renderer
        end

        attr_accessor :url, :credentials, :remote_dom_id, :partial # to replace with local content
        
        def initialize(options={},&block)
          super(options,&block)
        end
      end
    end
  end
end
