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
             :custom_fields_projects, :custom_fields_trackers,
             :project_types

    # def test_existence_of_associated_projects_table_in_project_overview
    #   log_user('jsmith', 'jsmith')
    #   project_type1 = ProjectType.find(1)
    #   project_type2 = ProjectType.find(2)
    #   project_type2.subordinates << project_type1
    #   project1 = project(id: 1, type: 1)
    #   project2 = project(id: 2, type: 2)
    #   project2.hosts << project1
    #   assert_equal 1, project2.hosts.count
    #   get project_path(id: 2)
    #   assert_response :success
    #   assert_select 'h3', l(:label_assigned_project_plural)
    # end

    def test_existence_of_host_checkboxes_in_project_settings
      project1 = project(id: 3, type: 1)
      log_user('admin', 'admin')
      get settings_project_path(project1.reload)
      assert_response :success
      assert_select '#host_projects'
    end

    def test_existence_of_subordinated_project_types
      project_type = ProjectType.find(1)
      log_user('admin', 'admin')
      get edit_project_type_path(project_type)
      assert_response :success
      assert_select '#subordinated_project_types', 1
    end

    def test_existence_of_host_projects_in_project_types_index
      log_user('admin', 'admin')
      get project_types_path
      assert_response :success
      assert_select '.relation', 3
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
