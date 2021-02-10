# Redmine plugin for xmera called Project Types Relations Plugin.
#
# Copyright (C) 2017-19 Liane Hampe <liane.hampe@xmera.de>.
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

module ProjectTypesRelations
  module Patches
    module ProjectsControllerPatch
        def update
          @project.safe_attributes = params[:project]
          if @project.save
            ProjectTypes::Integrations::ProjectsController.update(params, @project)
            ProjectTypesRelations::Integrations::ProjectsController.update(params, @project)
            respond_to do |format|
              format.html {
              flash[:notice] = l(:notice_successful_update)
              redirect_to settings_project_path(@project)
              }
              format.api  { render_api_ok }
            end
          else
            respond_to do |format|
              format.html {
              settings
              render :action => 'settings'
              }
              format.api  { render_validation_errors(@project) }
            end
          end
        end
    end
  end
end

# Apply patch
# ActiveSupport::Reloader.to_prepare do
#   unless ProjectsController.included_modules.include?(ProjectTypesRelations::Patches::ProjectsControllerPatch)
#     ProjectsController.prepend(ProjectTypesRelations::Patches::ProjectsControllerPatch)
#   end
# end
