class MeteorWidgetGenerator < Rails::Generator::NamedBase
  def manifest
    record do |m|
      m.directory "lib/meteor/widget/#{file_name}"
      m.template "spec.rb", "lib/meteor/widget/#{file_name}/spec.rb"
      m.directory "app/views/meteor/#{file_name}"
      m.template "_render.rhtml", "app/views/meteor/#{file_name}/_render.rhtml"
    end
  end
end
