# frozen_string_literal: true

# Redmine plugin for xmera called Project Types Relations Plugin.
#
# Copyright (C) 2017-2023 Liane Hampe <liaham@xmera.de>, xmera Solutions GmbH.
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

require File.expand_path('../test_helper', __dir__)

# Considers a namespace for LayoutTest since it might get superclass mismatches when using
# the class name more than once.
module ProjectTypesRelations
  class LayoutTest < Redmine::IntegrationTest
    include Redmine::I18n
    include ProjectTypesRelations::LoadFixtures
    include ProjectTypesRelations::AuthenticateUser
    include ProjectTypesRelations::ProjectTypeCreator

    set_fixture_class project_types: Project

    fixtures :projects, :issue_statuses, :issues,
             :enumerations, :issue_categories,
             :projects_trackers, :trackers,
             :roles, :member_roles, :members, :users,
             :custom_fields, :custom_values,
             :custom_fields_projects, :custom_fields_trackers

    def test_existence_of_associated_projects_table_in_project_overview
      project_type4 = find_project_type(id: 4)
      project_type5 = find_project_type(id: 5)
      project_type4.subordinates << project_type5
      project1 = project(id: 1, type: 4)
      project2 = project(id: 2, type: 5)
      project2.hosts << project1
      log_user('jsmith', 'jsmith')
      assert_equal 1, project2.hosts.count
      get project_path(id: 2)
      assert_response :success
      assert_select 'h3', l(:label_assigned_project_plural)
    end

    def test_existence_of_host_projects_in_project_types_index
      find_project_type(id: 4)
      find_project_type(id: 5)
      log_user('admin', 'admin')
      get project_types_path
      assert_response :success
      assert_select '.relation', 2
    end

    private

    def project(id:, type: nil)
      project = Project.find(id.to_i)
      project.project_type_id = type
      project.save
      project
    end
  end
end
