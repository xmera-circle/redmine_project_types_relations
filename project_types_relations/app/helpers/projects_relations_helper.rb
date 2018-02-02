module ProjectsRelationsHelper
  def related_projects_multiselect(project_id, choices, label,options={})
    
    related_projects = ProjectsRelation.where(project_id: project_id).pluck(:related_project)
    related_projects = [] unless related_projects.is_a?(Array)

    content_tag("label", l(label) ) +
      hidden_field_tag("projects_relation[related_project][]", '').html_safe +
      choices.collect do |choice|
        text, value = (choice.is_a?(Array) ? choice : [choice, choice])
        content_tag(
          'label',
          check_box_tag(
             "projects_relation[related_project][]",
             value,
             related_projects.include?(value),
             :id => nil
           ) + text.to_s,
          :class => 'inline' #'block'
         )
      end.join.html_safe
  end
  
 
  def create_multi_related_projects(record_set, parameters)
      record_set.delete_all
        parameters[:related_project].each do |i|
            if !i.empty?
              record_set.create!( related_project: i)
            end
        end
  end
  
  def related_projects_choice_set(project_id)
    
    projects_project_type = ProjectsProjectType.find_by( project_id: project_id )
    
    unless projects_project_type.nil?
      project_type_id = projects_project_type.project_type_id
      unless project_type_id.nil?
        related_project_type_id = ProjectType.find( project_type_id ).related_to
        unless related_project_type_id.nil?
          related_project_ids = ProjectsProjectType.where( project_type_id: related_project_type_id ).pluck( :project_id )
          unless related_project_ids.empty?
            return Project.where( id: related_project_ids )
          end
          return nil
        end
        return nil
      end
      return nil
    end
    return nil
  end
  
  def assigned_project_tree(given_project)
    tree = []
    i = 0 
    ProjectType.relation_order.collect { |type|
      tree[i] = [] 
      # Is type the project type of the given project?
      if type.projects.include?(given_project)
        tree[i].push(project_type_name(type))
        tree[i].push(given_project_name(given_project))
      else 
        if up_assigned_projects(given_project, type).present? || down_assigned_projects(given_project, type).present?
          tree[i].push(project_type_name(type))
        end
        # Check whether the projects of a project type are up related to the given_project
        tree[i].push(up_assigned_projects(given_project, type)) 
        # Check whether the projects of a project type are down related to the given_project
        tree[i].push(down_assigned_projects(given_project, type)) 
      end
      i = i + 1
      tree[i-1]
      }
  end
  
  def render_assigned_project_tree(project)
    tree = assigned_project_tree(project)
    tree.each{ |ar|
      ar.each{ |en| }.join(",").html_safe
    }.join("\n").html_safe 
  end
  
  def down_assigned_projects(project, type)   
      tag = content_tag :p, 
                  type.projects.to_a.collect{|p|
                  if project.relations_down? 
                    if project.relations_down.has?(p)
                        link_to p, 
                        project_path(p), 
                        :class => p.css_classes
                    end
                  end   
                  }.compact.join(", ").html_safe  
                  
      tag != "<p></p>" ? tag : nil
  end
  
  def up_assigned_projects(project, type)
      tag = content_tag :p,
                
                  type.projects.to_a.collect{|p|
                  if project.relations_up? 
                    if project.relations_up.has?(p)
                        link_to p, 
                        project_path(p), 
                        :class => p.css_classes
                    end
                  end    
                  }.compact.join(", ").html_safe
 
      tag != "<p></p>" ? tag : nil
  end
  
  def project_type_name(project_type)
    content_tag :h4, project_type.name
  end
  
  def given_project_name(given_project)
    content_tag :p, given_project.name
  end
  
end
# To access private helper methods
ProjectsController.send(:helper, ProjectsRelationsHelper)