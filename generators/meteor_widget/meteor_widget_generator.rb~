class MeteorGenerator < Rails::Generator::Base

  def recursive_copy(m,base,root=nil)
    Dir.new("#{base}").each do |dir|
      if root
        root_text = "#{root}/"
        new_root = "#{root}/#{dir}"
      else
        root_text = ""
        new_root = dir
      end
      if File.directory? "#{base}/#{dir}"
        next if dir == "." or dir == ".."
        m.directory "#{root_text}#{dir}"
        
        recursive_copy(m,"#{base}/#{dir}",new_root)
      else
        m.file "#{root_text}#{dir}", "#{root_text}#{dir}"
      end
    end
  end
      
  def manifest
    record do |m|
      recursive_copy(m,File.expand_path("../templates", __FILE__))
    end
  end
end
