require 'rubygems'
require 'ckuru-tools'
require 'ruby-debug'

class MeteorPluginWidgetGenerator < Rails::Generator::NamedBase
  def manifest
    record do |m|
      args.each do |arg|
        m.directory "vendor/plugins/#{file_name}/lib/meteor/widget/#{arg}"
        m.template "meteor_widget_plugin.rb", "vendor/plugins/#{file_name}/lib/meteor/widget/#{arg}/meteor_widget_plugin.rb"
        m.template "spec.rb", "vendor/plugins/#{file_name}/lib/meteor/widget/#{arg}/spec.rb"
        m.directory "vendor/plugins/#{file_name}/templates/#{arg}"

        m.template "_render.rhtml", "vendor/plugins/#{file_name}/templates/#{arg}/_render.rhtml"
      end
    end
  end
end
