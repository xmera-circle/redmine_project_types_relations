# frozen_string_literal: true

# Redmine plugin for xmera called Project Types Relations Plugin.
#
# Copyright (C) 2017-22 Liane Hampe <liaham@xmera.de>, xmera.
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

require_dependency 'project_types_relations'

Redmine::Plugin.register :redmine_project_types_relations do
  name 'Project Types Relations Plugin'
  author 'Liane Hampe'
  description 'This is a plugin for setting project types in relation to each other.'
  version '2.0.4'
  url 'https://circle.xmera.de/projects/redmine-project-types-relations'
  author_url 'https://circle.xmera.de/users/5'

  requires_redmine version_or_higher: '4.1.1'
  requires_redmine_plugin :redmine_project_types, version_or_higher: '4.0.0'
end

ActiveSupport::Reloader.to_prepare do
  unless ProjectsController.included_modules.include? SubordinatedProjectTypesHelper
    ProjectsController.helper(SubordinatedProjectTypesHelper)
  end
  ProjectsController.helper(HostProjectsHelper) unless ProjectsController.included_modules.include? HostProjectsHelper
  ProjectsController.helper(ProjectTypesHelper) unless ProjectsController.included_modules.include? ProjectTypesHelper
end
