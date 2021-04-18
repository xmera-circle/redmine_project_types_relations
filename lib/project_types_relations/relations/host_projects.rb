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
        base.include InstanceMethods
        base.class_eval do
          has_many :projects_relations,
                    foreign_key: :guest_id,
                    dependent: :destroy

          has_many :hosts,
                   through: :projects_relations,
                   source: :host

          validates :project_type_id, relation_integrity: true, on: :update

          safe_attributes :host_ids
        end
      end

      module ClassMethods
        def hosts_for_select(project)
          ids = project.project_type.subordinate_ids
          Project.projects.active.where(project_type_id: ids).includes(:project_type).select(:id, :name, :project_type_id)
        end
      end

      module InstanceMethods
        ##
        # A Project instance may request quite often its guests. This will
        # happen especially in RelationIntegrityValidator when looking for
        # lost guests. Therefore, guests are saved in an instance variable.
        #
        # @note There is a drawback: When a project has already at least one
        #  guest and another project sets its hosts with this project then
        #  it won't be recocnised until the instance is thrown away and created
        #  newly.
        #
        # @return [Array(Project)] An array of guest projects which is empty if
        #  there are no guests.
        #
        def guests
          return @guests if @guests.present?

          @guests = ProjectsRelation.guests(id).includes(:guest).map(&:guest)
        end

        def guest_ids
          return @guest_ids if @guest_ids.present?

          @guest_ids = ProjectsRelation.guests(id).includes(:guest).pluck(:guest_id)
        end

        def guests_count
          guest_ids.count
        end

        def project_type_id_unchanged?
          !project_type_id_changed?
        end

        def project_independent?
          hosts.none? && guests.none?
        end

        ##
        # A project has deprecated hosts if there is any host having a project_type
        # what is not consistend with any of the subordinates of the new
        # project type .
        #
        #
        def deprecated_hosts
          return unless qualified_to_be_deprecated?

          deprecated = []
          hosts.select do |host|
            deprecated << host unless related_project_type?(host)
          end
          deprecated
        end

        def related_project_type?(host)
          project_type.subordinate_ids.include? host.project_type_id
        end

        def qualified_to_be_deprecated?
          hosts.present? || project_type || project_type.subordinates.present?
        end

        def deprecated_hosts?
          deprecated_hosts.any?
        end

        def deprecated_hosts_count
          deprecated_hosts.count
        end

        def deprecated_hosts_message
          l(:error_deprecated_host_projects, count: deprecated_hosts_count)
        end

        def lost_guests_message
          l(:error_lost_guest_projects, count: guests_count)
        end
      end
    end
  end
end
