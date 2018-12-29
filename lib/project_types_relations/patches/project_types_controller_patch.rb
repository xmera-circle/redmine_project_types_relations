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

require_dependency 'project_types_controller'

module ProjectTypesRelations
  module Patches
    module ProjectTypesControllerPatch
      def self.included(base) 
        base.send(:include, InstanceMethods)
        base.class_eval do
          unloadable # Send unloadable so it will not be unloaded in development
                
          # Core Extensions
          alias_method_chain :index, :project_type_relation_setting
          alias_method_chain :project_type_params, :related_to_column
        end
      end
      
      module ClassMethods  
      end
      
      module InstanceMethods 
        def index_with_project_type_relation_setting
          @project_type = ProjectType
          index_without_project_type_relation_setting
        end
        
        private
        
        def project_type_params_with_related_to_column
          params.require(:project_type).permit(:name, :description, :identifier, :is_public, :default_user_role_id, :related_to, :position )
        end
      end
    end
  end
end

# Apply patch
Rails.configuration.to_prepare do
  unless ProjectTypesController.included_modules.include?(ProjectTypesRelations::Patches::ProjectTypesControllerPatch)
    ProjectTypesController.send(:include, ProjectTypesRelations::Patches::ProjectTypesControllerPatch)
  end
end
