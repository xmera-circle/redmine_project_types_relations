# frozen_string_literal: true

#
# Redmine plugin called Project Types Plugin.
#
# Copyright (C) 2017-21 Liane Hampe <liaham@xmera.de>, xmera.
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
  module Relations
    module SubordinatedProjectTypes
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def subordinated_project_types
          unless included_modules.include?(ProjectTypesRelations::Relations::SubordinatedProjectTypes::InstanceMethods)
            send :include, ProjectTypesRelations::Relations::SubordinatedProjectTypes::InstanceMethods
          end

          has_many :project_types_relations,
                   foreign_key: :superordinate_id,
                   dependent: :destroy

          has_many :subordinates,
                   through: :project_types_relations,
                   source: :subordinate,
                   autosave: true


          safe_attributes :subordinate_ids
        end
      end

      module InstanceMethods
        def superordinates
          return @superordinates if @superordinates.present?

          @superordinates = ProjectTypesRelation.superordinates(id)
        end

        def superordinate_ids
          superordinates&.map(&:id)
        end
      end
    end
  end
end
