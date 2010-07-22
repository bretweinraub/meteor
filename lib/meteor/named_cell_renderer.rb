module Meteor

  class NamedCellRenderer < RendererBase

    ################################################################################ 

    
    #
    # deprecated; use data_for_render()
    #

    def object
      ckebug 0, "Deprecated; use data_for_render()"
      if val = instance_variable_get("@object")
        val
      else 
        # load object if it hasn't been loaded yet
        self.object = spec.klass.find(id)
      end
    end
    
    ################################################################################ 

    def do_crud_inplace_select_edit(page,params)
      begin
        cell_name = params['cell_name']
        value = params['value']

#        raise "cannot load object of type #{_klass} with id #{id}" unless object = klass.find(id)

        object.send("#{cell_name}=",value)
        object.save!
        object.reload
        cell_id = params["cell_id"]

        cell = spec.find_cell_by_name(cell_name.to_sym)

        new_value = object.send(cell_name) 
        if new_value.is_a? String
          display_value = new_value
        else
          [:name,:to_label,:to_s].each do |meth|
            if new_value.respond_to?(meth)
              display_value = new_value.send(meth)
              break
            end
          end
        end
        
        page.replace_html cell_id, display_value
        
        cell.send(:event_handler,:after_render,
                  {
                    :renderer => self,
                    :page => page,
                    :params => params,
                    :object => object}
                  ) if cell.respond_to?(:event_handler)
      end
    end

  end
end
