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

require_dependency 'project'

module ProjectTypesRelations
  module Patches
    module ProjectPatch
      def self.included(base)
        base.extend(ClassMethods)  
        base.send(:include, InstanceMethods)    
        base.class_eval do   
          # Associations
          has_many :projects_relations, foreign_key: :project_id, dependent: :destroy  
        end
      end
    
      module ClassMethods 
      end
      
      module InstanceMethods
      end
    end
  end
end

# Apply patch
Rails.configuration.to_prepare do
  unless Project.included_modules.include?(ProjectTypesRelations::Patches::ProjectPatch)
    Project.send(:include, ProjectTypesRelations::Patches::ProjectPatch)
  end
end