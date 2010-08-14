
module Meteor
  def render_meteor_widget(name,h={})
    spec=meteor_spec(name)
    call_args = {
      :controller => self,
      :params => request.params
    }
    spec.render(call_args.merge!(h))
  end
end
