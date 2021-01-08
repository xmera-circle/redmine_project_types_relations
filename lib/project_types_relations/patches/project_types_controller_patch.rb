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
    module ProjectTypesControllerPatch
      def self.included(base) 
        base.send(:prepend, InstanceMethods)
      end
 
      module InstanceMethods
        ##
        # Overwrite index action in order to set the class ProjectType
        #
        def index
          @project_type = ProjectType
          super
        end
        
        private

        ##
        # Overwrite project_type_params in order to add the related_to attribute
        #
        def project_type_params
          params.require(:project_type).permit(:name, 
                                               :description, 
                                               :identifier, 
                                               :is_public, 
                                               :default_user_role_id, 
                                               :related_to, 
                                               :position )
        end
      end
    end
  end
end

# Apply patch
Rails.configuration.to_prepare do
  unless ProjectTypesController.included_modules.include?(ProjectTypesRelations::Patches::ProjectTypesControllerPatch)
    ProjectTypesController.send(:prepend, ProjectTypesRelations::Patches::ProjectTypesControllerPatch)
  end
end
