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
                   autosave: true,
                   before_remove: :check_existence_of_host_projects,
                   before_add: :check_reference

          safe_attributes :subordinate_ids
        end
      end

      module InstanceMethods
        def superordinates
          ProjectTypesRelation.where(subordinate_id: id).map(&:superordinate).compact
        end

        def superordinate_ids
          superordinates&.map(&:id)
        end

        private

        def check_existence_of_host_projects(subordinate)
          return unless subordinate.projects.any?

          errors.add :the_subordinate, l(:error_subordinates_have_projects_assigned, count: subordinate.projects.count)
          raise ActiveModel::ValidationError, self
        end

        def check_reference(subordinate)
          check_self_reference(subordinate) || check_circular_reference(subordinate)
        end

        def check_self_reference(subordinate)
          return unless self_reference?(subordinate)

          errors.add :project_type, l(:error_validate_self_relation)
          raise ActiveModel::ValidationError, self
        end

        def self_reference?(subordinate)
          return false unless subordinate.present?

          subordinate.id == id
        end

        def check_circular_reference(subordinate)
          return unless circular_reference?(subordinate)

          errors.add :project_type, l(:error_validate_circular_reference)
          raise ActiveModel::ValidationError, self
        end

        def circular_reference?(subordinate)
          return false unless subordinate.present?

          filter_for_superordinate_ids.include? subordinate.id
        end

        def filter_for_superordinate_ids
          ProjectTypesRelation.where(subordinate_id: id).pluck(:superordinate_id)
        end
      end
    end
  end
end
