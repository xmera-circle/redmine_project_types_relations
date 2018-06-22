require_dependency 'projects_controller'

    module ProjectsControllerPatch
      
      def self.included(base) 
        base.send(:include, InstanceMethods)
        base.extend(ClassMethods)

        alias_method_chain :show, :project_relations
        
      end
      
      module ClassMethods
      end # module ClassMethods
      
      module InstanceMethods
        
        def show_with_project_relations
          show_without_project_relations
        end
      
      end # module InstanceMethods
      
    end # module IssuesControllerPatch

ProjectsController.send(:include, ProjectsControllerPatch)