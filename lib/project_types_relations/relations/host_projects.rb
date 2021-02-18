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
    module HostProjects
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def hosted_projects
          unless included_modules.include?(ProjectTypesRelations::Relations::HostProjects::InstanceMethods)
            send :include, ProjectTypesRelations::Relations::HostProjects::InstanceMethods
          end

          has_many :projects_relations,
                   foreign_key: :guest_id,
                   dependent: :destroy

          has_many :hosts,
                   through: :projects_relations,
                   source: :host,
                   autosave: true

          validate :check_integrity_of_relations, on: :update

          safe_attributes :host_ids
        end
      end

      module InstanceMethods
        def guests
          ProjectsRelation.where(host_id: id).map(&:guest).compact
        end

        def guest_ids
          guests&.map(&:id)
        end

        private

        def check_integrity_of_relations
          return if project_type_id_unchanged? || independent?

          errors.add :project_type, l(:error_project_has_guest_projects) if guests.any?
          errors.add :project_type, l(:error_project_has_invalid_host_projects) if deprecated_hosts?
        end

        def project_type_id_unchanged?
          !project_type_id_changed?
        end

        def independent?
          hosts.none? && guests.none?
        end

        def dependent?
          hosts.any? && guests.any?
        end

        ##
        # A project has deprecated hosts if there is any host having a project_type
        # what is not consistend with any of the project's project type subordinates.
        #
        def deprecated_hosts?
          hosts.none? { |host_project| project_type.subordinate_ids.include? host_project.project_type_id }
        end
      end
    end
  end
end
