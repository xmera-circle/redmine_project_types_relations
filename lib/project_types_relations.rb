# frozen_string_literal: true

# Redmine plugin for xmera called Project Types Relations Plugin.
#
# Copyright (C) 2017-2023 Liane Hampe <liaham@xmera.de>, xmera Solutions GmbH.
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.

# Extensions
require_relative 'project_types_relations/extensions/project_patch'
require_relative 'project_types_relations/extensions/subordinated_project_types'
require_relative 'project_types_relations/extensions/host_projects'
require_relative 'project_types_relations/extensions/null_project_type_patch'

# Hooks
require_relative 'project_types_relations/hooks/view_projects_form_hook_listener'
require_relative 'project_types_relations/hooks/view_layouts_base_html_head_hook_listener'
require_relative 'project_types_relations/hooks/view_projects_show_right_hook_listener'
require_relative 'project_types_relations/hooks/view_project_types_form_top_hook_listener'
require_relative 'project_types_relations/hooks/view_project_types_form_top_of_associates_hook_listener'
require_relative 'project_types_relations/hooks/view_project_types_table_header_hook_listener'
require_relative 'project_types_relations/hooks/view_project_types_table_data_hook_listener'

# Overrides
require_relative 'project_types_relations/overrides/projects_controller_patch'

module ProjectTypesRelations
  class << self
    def setup
      %w[project_patch
         null_project_type_patch
         projects_controller_patch].each do |patch|
        AdvancedPluginHelper::Patch.register(send(patch))
      end
      AdvancedPluginHelper::Patch.apply do
        { klass: ProjectTypesRelations,
          method: :add_helpers }
      end
    end

    private

    def null_project_type_patch
      { klass: NullProjectType,
        patch: ProjectTypesRelations::Extensions::NullProjectTypePatch,
        strategy: :prepend }
    end

    def project_patch
      { klass: Project,
        patch: ProjectTypesRelations::Extensions::ProjectPatch,
        strategy: :include }
    end

    def projects_controller_patch
      { klass: ProjectsController,
        patch: ProjectTypesRelations::Overrides::ProjectsControllerPatch,
        strategy: :prepend }
    end

    def add_helpers
      ProjectsController.helper(SubordinatedProjectTypesHelper)
      ProjectsController.helper(HostProjectsHelper)
      ProjectsController.helper(ProjectTypesHelper)
    end
  end
end
