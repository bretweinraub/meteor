class Symbol
  def gsub(*args,&block)
    self.to_s.gsub(*args,&block)
  end
end

class String

  # not perfect:
  # >> "BDWAcontractProduct".de_camelize
  # => "b_d_w_acontract_product"
  # >> 

  def de_camelize
    self.split(/(?=[A-Z])/).map{|w| w.downcase}.join("_")
  end
end
