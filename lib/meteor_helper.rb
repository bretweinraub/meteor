module MeteorHelper
  # Render the various css/image/javascript includes for meteor
  def meteor_includes
    render :partial => 'meteor/includes'
  end

  # Return equality of two objects casts as strings
  def option_equal(val1, val2)
    val1.to_s == val2.to_s
  end

  # Object to string.  Replace blanks with something nice.
  def replace_blank(s, substitute='-')
    if not s.kind_of? String
      s = s.to_s
    end
    if s.blank?
      s = substitute
    end
    s
  end
end

