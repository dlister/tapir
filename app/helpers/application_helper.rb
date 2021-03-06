module ApplicationHelper

  def render_children(entity, result = "")
    # Base case 
    return result = "" if entity.children.empty?
    
    result << "<ul>"  
    entity.children.each do |x|
      result << print_result(x)
      next if x.children.include? entity
      render_children(x, result) 
    end
    result << "</ul>"

  result 
  end

  def render_parents(entity, result = "", depth=0)
    
    if entity.parents.empty?
      # Base case - Close up the upper-lists
      depth.times do result << "</ul>" end
      return result
    else
      depth = depth + 1
    end
    
    entity.parents.each do |x|
      next if x.parents.include? entity
      
      # Print this parent at the beginning of the string
      result.prepend print_result(x)
      result.prepend "<ul>"

      # Recurse on the child
      render_parents(x, result, depth)
    end
    result
  end

  def print_result(entity)
    # << " (#{item.task_runs.where(:task_entity_id => item.id).first}) " 
    "<li>" << link_to(entity, entity_path(entity)) << "</li>"   
  end

  # Return the valid entity types
  def get_valid_type_class_names
    types = Entities::Base.descendants.map{|x| x.name.split("::").last}
  types.sort_by{ |t| t.downcase }
  end

  private  
    # Return the valid entity types
    def _get_valid_types
      types = Entities::Base.descendants
    end

end
