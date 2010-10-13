require 'rubygems'
require 'ckuru-tools'

class MeteorPluginGenerator < Rails::Generator::NamedBase
  
  def manifest
    docmd("script/generate plugin #{class_name}")
    ckebug 0, "WARNING ... due to either limitations with Rake, Ruby and/or my own personal noob-factor/stupidity, we will need to overwrite the Rakefile created by script/generate plugin with our own Meteor specific Rakefile.  If this creates problems for you, please either add in whatever rake tasks you require in the generated rakefile or open a github tracker on the meteor plugin for this issue."
    File.delete("vendor/plugins/#{file_name}/Rakefile") # XXX - unfortunately we need to generate our own
    record do |m|
      m.directory "vendor/plugins/#{file_name}/lib/meteor/widget/#{file_name}"
      m.template "meteor_widget_plugin.rb", "vendor/plugins/#{file_name}/lib/meteor/widget/#{file_name}/meteor_widget_plugin.rb"
      m.template "spec.rb", "vendor/plugins/#{file_name}/lib/meteor/widget/#{file_name}/spec.rb"
      m.directory "vendor/plugins/#{file_name}/templates/#{file_name}"

      # build directories to hold public docs/assets that are part of the plugin
      %w{images javascripts stylesheets}.each do |public_dir|
        m.directory "vendor/plugins/#{file_name}/public/#{public_dir}"
      end
      # m.directory "lib/tasks/meteor"
      # m.template "load_meteor_rake_tasks.rb", "vendor/plugins/#{file_name}/lib/tasks/meteor"
      # m.template "install_assets.rake", "vendor/plugins/#{file_name}/lib/tasks/meteor/install_assets.rake"
      m.template "Rakefile", "vendor/plugins/#{file_name}/Rakefile"
      m.template "_render.rhtml", "vendor/plugins/#{file_name}/templates/#{file_name}/_render.rhtml"
    end
  end
end
