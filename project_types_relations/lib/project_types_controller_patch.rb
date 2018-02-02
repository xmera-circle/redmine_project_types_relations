require_dependency 'project_types_controller'

module ProjectTypesControllerPatch
  def self.included(base) # :nodoc:
    base.send(:include, InstanceMethods)
    
    base.class_eval do
      unloadable # Send unloadable so it will not be unloaded in development
            
      # Core Extensions
      alias_method_chain :index, :project_type_relation_setting
      alias_method_chain :project_type_params, :related_to_column

    end
  end
  
  module ClassMethods
    
  end # module ClassMethods
  
  module InstanceMethods
    
    def index_with_project_type_relation_setting
      @project_type = ProjectType
      index_without_project_type_relation_setting
    end
    
    private
    
    def project_type_params_with_related_to_column
      params.require(:project_type).permit(:name, :description, :identifier, :is_public, :default_user_role_id, :related_to, :position )
    end
  end # module InstanceMethods

end # module ProjectTypesControllerPatch

ProjectTypesController.send(:include, ProjectTypesControllerPatch)
