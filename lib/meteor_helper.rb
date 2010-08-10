module MeteorHelper
  def option_equal(val1,val2)
    val1.to_s == val2.to_s
  end

  def replace_blank(s, substitute='-')
    if not s.kind_of? String
      s = s.to_s
    end
    if s.blank?
      s = substitute
    end
    s
  end

  def meteor_includes
    render :partial => 'meteor/includes'
  end
end

