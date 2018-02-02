require_dependency 'projects_project_type'

module ProjectsProjectTypePatch
  
  def self.included(base) # :nodoc:
    base.extend(ClassMethods)
    
    base.send(:include, InstanceMethods)
    
    base.class_eval do
      unloadable # Send unloadable so it will not be unloaded in development
      
      # Callbacks
      before_save :clean_up
  
    end
   end
  
  module ClassMethods
    
  end
  
  module InstanceMethods

  private
  
  def clean_up
   project = Project.find(project_id)

   unless project.projects_project_type.nil?
     project.projects_project_type.attributes = {project_type_id: project_type_id}
  
     if project.projects_project_type.changed?  && ProjectsRelation.where(project_id: project_id).present?
       ProjectsRelation.where(project_id: project_id).delete_all
     end
  
     if project.projects_project_type.project_type_id.nil?
       ProjectsProjectType.find_by(project_id: project_id).delete
     end
   end 
  end  
 end # module InstanceMethods
  
end # module ProjectsProjectTypePatch

ProjectsProjectType.send(:include, ProjectsProjectTypePatch)