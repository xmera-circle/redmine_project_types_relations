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

#require File.join(Rails.root, 'plugins/project_types/app/models/projects_project_type.rb')

module ProjectTypesRelations
  module Patches
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
     end
    end
  end
end

# Apply patch
Rails.configuration.to_prepare do
  unless ProjectsProjectType.included_modules.include?(ProjectTypesRelations::Patches::ProjectsProjectTypePatch)
    ProjectsProjectType.send(:include, ProjectTypesRelations::Patches::ProjectsProjectTypePatch)
  end
end