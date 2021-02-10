require_relative '../../../app/helpers/projects_relations_helper'

module ProjectTypesRelations
  module Integrations
    module ProjectsController

      extend ::ProjectsRelationsHelper
      module_function

      def update(params, project)
        unless params[:projects_relation].nil? || project.projects_project_type.previous_changes.present?
          projects_relations = ProjectsRelation.where(project_id: project.id)
          create_multi_related_projects(projects_relations, projects_relation_params(params))
        end
      end

      def projects_relation_params(params)
        params.require(:projects_relation).permit(:project_id, :related_project => [])
      end
    end
  end
end

# ActiveSupport::Reloader.to_prepare do
#   unless ProjectTypes::Integrations::ProjectsController.included_modules.include?(ProjectTypesRelations::Patches::ProjectsControllerIntegrationPatch)
#     ProjectTypes::Integrations::ProjectsController.prepend(ProjectTypesRelations::Patches::ProjectsControllerIntegrationPatch)
#   end
# end