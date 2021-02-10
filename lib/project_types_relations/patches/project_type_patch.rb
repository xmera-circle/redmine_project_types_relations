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

#require File.join(Rails.root, 'plugins/project_types/app/models/project_type.rb')

module ProjectTypesRelations
  module Patches
    module ProjectTypePatch 
      def self.prepended(base)
        base.extend ClassMethods     
        base.prepend InstanceMethods     
        base.class_eval do
          validates :related_to, uniqueness: true, allow_blank: true, allow_nil: true
          validate :validate_relation, on: :update
          validate :validate_is_project_type     
        end
       end
      
      module ClassMethods; end
      
      module InstanceMethods
        def validate_relation
            errors.add(:related_to, l(:error_validate_relation)) if related_to_self?
          end
        end
        
        def validate_is_project_type
          unless not_related?
            unless project_type?(related_to)
              errors.add(:related_to, l(:error_validate_is_project_type))
            end
          end
        end

        private

        def related_to_self?
          id == related_to
        end        

        def not_related?
          related_to.nil? || related_to.blank?
        end

        def project_type?(id)
          ProjectType.find_by(id: id.to_i)&.is_a?(ProjectType)
        end

      end  
    end
  end
end

# Apply patch
Rails.configuration.to_prepare do
  unless ProjectType.included_modules.include?(ProjectTypesRelations::Patches::ProjectTypePatch)
    ProjectType.send(:prepend, ProjectTypesRelations::Patches::ProjectTypePatch)
  end
end