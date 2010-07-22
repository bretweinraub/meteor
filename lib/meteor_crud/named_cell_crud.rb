module NamedCellCrud

  include MeteorCrudBase

  ################################################################################ 

  def named_cell_inplace_edit
    
    spec_name = params['spec']
    raise "cannot find meteor spec for #{spec_name}" unless spec = meteor_specs[spec_name]
    
    raise 'cannot determine object class' unless _klass = params['object_class']
    raise "no such class #{_klass}" unless klass = self.class.const_get(_klass)

    id = params['id']
    raise "cannot load object of type #{_klass} with id #{id}" unless object = klass.find(id)

    cell_name = params['cell_name']
    value = params['value']
    
    object.send("#{cell_name}=",value)
    object.save!
    object.reload
    
    render :layout => false, :text => object.send(cell_name.to_sym).to_s
  end
end
