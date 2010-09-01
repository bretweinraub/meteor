class MeteorPluginGenerator < Rails::Generator::NamedBase
  
  require 'ruby-debug'


  def manifest
    
    system("script/generate plugin #{class_name}")
    record do |m|
      m.directory "vendor/plugins/#{file_name}/lib/meteor/widget/#{file_name}"
      m.template "meteor_widget_plugin.rb", "vendor/plugins/#{file_name}/lib/meteor/widget/#{file_name}/meteor_widget_plugin.rb"
      m.template "spec.rb", "vendor/plugins/#{file_name}/lib/meteor/widget/#{file_name}/spec.rb"
      m.directory "vendor/plugins/#{file_name}/templates/#{file_name}"
      m.template "_render.rhtml", "vendor/plugins/#{file_name}/templates/#{file_name}/_render.rhtml"
    end
  end
end
