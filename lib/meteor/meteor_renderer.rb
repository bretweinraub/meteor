require File.join(File.dirname(__FILE__),'renderer_base')

module Meteor
  
  ################################################################################
  ################################################################################
  
  class MeteorRenderer < RendererBase

    #
    # Override this to render different data.
    #

    def data_for_render
      spec.klass.send(:find_by_sql,sql)
    end

    #
    # This routine returns the SQL query used to return the driving data for this meteor widget.
    # You MUST define your driving query here (RendererBase doesn't have a default).
    #

    def sql_query

      if spec.klass.columns.select {|col| col.name == "id"}.length > 0 
        # active record
        "select * from #{spec.klass.table_name} where #{spec.parent_klass.table_name.singularize}_id = #{id}" 
      else
        # m80
        is_deleted_clause = spec.klass.columns.select {|col| col.name == "is_deleted"}.length > 0 ? " and is_deleted <> 'Y'" : ""

        "select * from #{spec.klass.table_name} where #{spec.parent_klass.primary_key} = #{id} #{is_deleted_clause}" 
      end

    end

    ################################################################################
    #     def self.build_default(klass)
    #       raise "#{klass} not a child of ActiveRecord::Base" unless
    #         klass.is_a?(ActiveRecord::Base)
    #     end
    ################################################################################

    def do_crud_delete(page,params)
      error_div = params["error_div"] # 
      id = params["id"] # 8239
      indicator = params["indicator"] # meteor_contract_product_6088_8239_indicator
      _klass = params["klass"] # ContractProduct
      
      parent_klass = params["parent_klass"] # Contract

      execute_block_with_error_div(page,error_div,indicator) do
        raise "no such class #{klass} in #{current_method}" unless klass = self.class.const_get(_klass)

        obj = klass.find(id)

        if obj.attributes.has_key?("is_deleted")
          obj.is_deleted = 'Y'
          obj.save
        else
          raise "hard delete not implemented"
        end

        crud_delete_render(:page => page,
                           :deleted_object => obj,
                           :params => params)
      end
    end

    ################################################################################

    def do_crud_submit(page,params)
      raise "no contents in params" unless contents = params["contents"] # 
      raise "no error_div in params" unless error_div = params["error_div"] # 

      id = params["id"] # 8253
      indicator = params["indicator"] # meteor_contract_product_6088_8253_indicator
      _klass = params["klass"] # ContractProduct
      name = params["name"] # contract_product

      execute_block_with_error_div(page,error_div,indicator) do
        formdata = params[name] # mrc_burst_sell0.0termMonthlywbsproduct_id302mrc_sell0.0nrc_cost0.0notescustomer_commit0.0mrc_burst_cost0.0mrc_cost0.0nrc_sell0.0duration0.0

        raise "no such class #{klass} in #{current_method}" unless klass = self.class.const_get(_klass)

        obj = klass.find(id) # load object
        begin
          orig_name = obj.send(:name)
        rescue Exception => e
          raise "cannot load name from #{obj}\n.  Frequently this is because class #{obj.class} does not define name method.\n#{e}"
        end

        formdata.keys.each do |key|
          obj.send("#{key}=".to_sym,formdata[key])
        end
        obj.save!
        obj.reload

        render_args = {:row => obj}
        
        params.keys.each do |k|
          render_args[k.to_sym] = params[k]
        end

        # when the name changes; we will re-render the entire blocl
        if obj.name != orig_name
          page.replace_html contents, conditionally_render_partial((spec.has_children? ? :row_interior : :row_data),
                                                                   render_args.merge(:editstate => true,
                                                                                     :expanded => true))
        else
          writerow = params["writerow"]
          readrow =  params["readrow"]
          page.replace_html writerow, conditionally_render_partial(:row_data_writerow, render_args)
          page.replace_html readrow, conditionally_render_partial(:row_data_readrow, render_args)
          page[writerow].hide
          page[readrow].show
        end
      end
    end

    ################################################################################

    def crud_delete_render(h={})
      page = h[:page]
      params = h[:params]
      contents = params["contents"]

      page.replace_html contents, '' if contents
    end

    ################################################################################

    def crud_add_render(h={})
      newobj = h[:newobj]
      page = h[:page]
      renderer = h[:renderer]
      params = h[:params]
      addform_table = h[:addform_table]

      if newobj.errors.empty?
        if spec.has_children?
          page.insert_html :top, params["tbody"], conditionally_render_partial(:row,h.merge(:row => newobj,
                                                                                            :expanded => true))
        else
          raise "no contents in params" unless contents = params["contents"]
          page.replace_html contents, conditionally_render_partial(:rows,h)
        end

        unless spec.retain_addform_after_add
          page.hide(addform_table)
        end
      else
        error_text = ""
        newobj.errors.each do |err|
          error_text += err.to_s
        end
        raise error_text
      end
    end

    ################################################################################

    def do_crud_add(page,params)
      error_div = params["error_div"]  # do this first so we can refer to it later
      _klass = params["klass"] # "ContractProduct", 
      name = params["name"]  #"contract_product", 

      _parent_klass = params["parent_klass"]  #"Contract", 
      id = params[:id] # =>"6088", 
      formdata = params[name] # "contract_product"=>{"term"=>"12", "wbsproduct_id"=>"290"}, 
      indicator = params["indicator"] #=>"meteor_contract_product_6088_addform_indicator"}
      
      raise "no such param \"addform_table\" in #{current_method}" unless addform_table = params["addform_table"] 

      raise "no such class #{klass} in #{current_method}" unless klass = self.class.const_get(_klass)

      execute_block_with_error_div(page,error_div,indicator) do
        parent_klass            = self.class.const_get(_parent_klass)
        ar_assoc                = klass.reflect_on_association(parent_klass.to_s.de_camelize.to_sym)
        primary_key_name        = ar_assoc.primary_key_name

        create_attributes                          = {}
        create_attributes[primary_key_name.to_sym] = id.to_i

        formdata.keys.each do |key|
          create_attributes[key.to_sym] = formdata[key]
        end

        newobj = new_object(:klass => klass,
                            :controller => controller,
                            :attributes => create_attributes)

        
        options = {:newobj => newobj,
          :page => page,
          :klass => klass,
          :parent_klass => parent_klass,
          :addform_table => addform_table,
          :params => params}

        params.keys.each do |k|
          options[k.to_sym] = params[k]
        end

        crud_add_render(options)
      end
    end
    
  end
  ################################################################################
  ################################################################################
end
