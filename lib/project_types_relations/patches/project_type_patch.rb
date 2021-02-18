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

# require File.join(Rails.root, 'plugins/project_types/app/models/project_type.rb')

module ProjectTypesRelations
  module Patches
    module ProjectTypePatch
      def self.prepended(base)
        base.extend(ClassMethods)
        base.prepend(InstanceMethods)
        base.class_eval do
          include ProjectTypesRelations::Relations::SubordinatedProjectTypes
          include ProjectTypesRelations::Relations::Enable
          include ProjectTypesRelations::Associations::SubordinatedProjectTypes

          after_initialize do
            enable(:subordinated_project_types) if ProjectTypes.any?
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
  unless ProjectType.included_modules.include?(ProjectTypesRelations::Patches::ProjectTypePatch)
    ProjectType.prepend ProjectTypesRelations::Patches::ProjectTypePatch
  end
end
