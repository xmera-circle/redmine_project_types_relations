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
                   dependent: :destroy,
                   autosave: true

          has_many :subordinates,
                   through: :project_types_relations,
                   source: :subordinate,
                   before_add: :circular_reference?,
                   before_remove: :close_relatives?,
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

        def circular_reference?(subordinate)
          return unless self?(subordinate.id) || subordinate.subordinate_assigned?(id)
          if self?(subordinate.id)
            errors.add subordinate.name, l(:error_validate_self_relation)
          else
            errors.add subordinate.name, l(:error_validate_circular_reference)
          end
          raise ActiveRecord::Rollback
        end

        ##
        # Validation needs to take place here since the destroy action
        # is not recognized in ProjectTypesRelation class.
        #
        def close_relatives?(subordinate)
          found = close_hosts(subordinate)
          return unless found.present?

          errors.add subordinate.name, l(:error_subordinates_have_projects_assigned, value: close_hosts_message)
          raise ActiveRecord::Rollback
        end

        def close_hosts(subordinate)
          search_close_hosts(load_close_hosts_candidates(subordinate))
        end

        def load_close_hosts_candidates(subordinate)
          ProjectType.masters.where(id: [id, subordinate.id]).includes(relatives: :hosts)
        end

        def search_close_hosts(candidates)
          candidates = candidates.dup.to_a
          candidates.reverse! unless candidates.first.id == id
          first = candidates.first.relatives.map(&:hosts).flatten
          last = candidates.last.relatives
          first & last
        end

        def close_hosts_message
          l(:error_projects_use_services, value: name)
        end

        def self?(other_id)
          id == other_id
        end
      end
    end
  end
end
