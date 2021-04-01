# frozen_string_literal: true

# Redmine plugin for xmera called Project Types Relations Plugin.
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
  module Patches
    module ProjectPatch
      def self.prepended(base)
        base.extend(ClassMethods)
        base.prepend(InstanceMethods)
        base.class_eval do
          include ProjectTypesRelations::Relations::Enable
          include ProjectTypesRelations::Relations::HostProjects   
          include ProjectTypesRelations::Associations::HostProjects
          include ProjectTypesRelations::Relations::SubordinatedProjectTypes
          include ProjectTypesRelations::Associations::SubordinatedProjectTypes

          after_initialize do
            enable(:hosted_projects)
            enable(:subordinated_project_types)
          end
        end
      end

      module ClassMethods; end

      module InstanceMethods; end
    end
  end
end

# Apply patch
Rails.configuration.to_prepare do
  unless Project.included_modules.include?(ProjectTypesRelations::Patches::ProjectPatch)
    Project.prepend(ProjectTypesRelations::Patches::ProjectPatch)
  end
end
