require File.dirname(__FILE__) + '/spec_helper'

describe ::Meteor::Widget::RemoteContent::Spec do
  
  context "with partial" do
    
    before(:all) do
      @content = ::Meteor::Widget::RemoteContent::Spec.new(:url           => "http://www.aura-software.com",
                                                           :remote_dom_id => ".section.content-body",
                                                           :partial       => "meteor/remote_content/test.rhtml").render
    end
  
    it "should render the specified remote content" do
      @content.should match(%r|</body>|)
    end
  
    it "should replace content with the provided partial" do
      @content.should match(%r|<div class="section content-body"><h3>Hello!</h3></div>|)
    end
  
  end
  
  context "without partial" do
    
    before(:all) do
      @content = ::Meteor::Widget::RemoteContent::Spec.new(:url           => "http://www.aura-software.com").render
    end
    
    it "should render the specified remote content" do
      @content.should match(%r|body|)
    end
  
    it "should not replace content as no partial is provided" do
      @content.should_not match(%r|<div class="section content-body"><h3>Hello!</h3></div>|)
    end
    
  end
  
end
