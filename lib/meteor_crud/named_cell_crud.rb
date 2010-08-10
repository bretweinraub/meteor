module NamedCellCrud
  include MeteorCrudBase

  ################################################################################

  def named_cell_inplace_edit
    id = params['id']
    cell_name = params['cell_name']
    spec_name = params['spec']

    raise "cannot find meteor spec for #{spec_name}" unless spec = meteor_specs[spec_name]
    raise 'cannot determine object class' unless _klass = params['object_class']
    raise "no such class #{_klass}" unless klass = self.class.const_get(_klass)
    raise "cannot load object of type #{_klass} with id #{id}" unless object = klass.find(id)

    if params['ref']
      _ref_klass = cell_name.capitalize
      raise "no such class #{_ref_klass}" \
        unless ref_klass = self.class.const_get(_ref_klass)
      if params['value'].blank?
        value = nil
      else
        value = ref_klass.find(params['value'])
      end
    else
      value = params['value']
    end
    object.send("#{cell_name}=", value)
    object.save!
    object.reload

    new_value = object.send(cell_name.to_sym)
    output = ""
    [:name, :to_label, :to_s].each do |method|
      if new_value.respond_to? method
        output = new_value.send(method)
        break
      end
    end
    if output.blank?
      output = '-'
    end

    render :inline => CGI.escapeHTML(output)
  end
end
