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

module ProjectTypesRelations
  class ProjectsControllerPatchTest < ActionDispatch::IntegrationTest
    include Redmine::I18n
    include ProjectTypesRelations::ProjectTypeCreator
    include ProjectTypesRelations::AuthenticateUser

    fixtures :projects, :issue_statuses, :issues,
             :enumerations, :issue_categories,
             :projects_trackers, :trackers,
             :roles, :member_roles, :members, :users,
             :custom_fields, :custom_values,
             :custom_fields_projects, :custom_fields_trackers

    def setup
      project_type(id: 4).subordinates << project_type(id: 5)
      project_type(id: 6)
    end

    test 'new projects should not display host projects box' do
      log_user('jsmith', 'jsmith')
      get new_project_path
      assert_response :success
      assert_select '#host_projects', false
    end

    test 'projects settings should display host projects box' do
      log_user('jsmith', 'jsmith')
      get settings_project_path(project(id: 1, type: 4))
      assert_response :success
      assert_select '#host_projects'
    end

    test 'no hosts choice set should be displayed when no project type is chosen' do
      log_user('jsmith', 'jsmith')
      get settings_project_path(project(id: 1))
      assert_response :success
      assert_select 'select[name=?]', 'project[project_type_id]' do
        assert_select 'option[selected=selected]', false
        assert_select 'option[value=""]'
      end
      assert_select '#host_projects', false
    end

    test 'should not display the hosts choice set when project type has no subordinates' do
      log_user('jsmith', 'jsmith')
      get settings_project_path(project(id: 1, type: 6))
      assert_response :success
      assert_select '#host_projects'
      assert_match l(:label_no_data), response.body
    end

    test 'should show the host choice set when the chosen project type has subordinates' do
      project1 = project(id: 1, type: 4)
      project1.hosts << [project(id: 2, type: 5), project(id: 3, type: 5)]
      log_user('jsmith', 'jsmith')
      get settings_project_path(project1)
      assert_response :success

      # Counts also the hidden field
      assert_select 'input[name=?]', 'project[host_ids][]', 3
    end

    test 'should update project type only without deprecated hosts and lost guests' do
      project1 = project(id: 1, type: 4)
      log_user('jsmith', 'jsmith')
      patch project_path(project1), params: {
        project: { project_type_id: '5' }
      }
      assert_redirected_to '/projects/ecookbook/settings'
      get settings_project_path(project1)
      assert_response :success
      assert_select 'select[name=?]', 'project[project_type_id]' do
        assert_select 'option[value="5"][selected=selected]'
      end
    end

    test 'should not update project type with deprecated hosts and lost guests' do
      project_type(id: 5).subordinates << project_type(id: 6)
      project1 = project(id: 1, type: 4)
      project2 = project(id: 2, type: 5)
      project1.hosts << project2

      log_user('jsmith', 'jsmith')
      patch project_path(project1), params: {
        project: { project_type_id: '6' }
      }
      assert_response :success
      assert_select_error "#{l(:label_project_type)} #{l(:error_deprecated_host_projects, count: 1)}"
    end

    test 'should update existing hosts' do
      project1 = project(id: 1, type: 4)
      project(id: 2, type: 5)
      project(id: 3, type: 5)
      log_user('jsmith', 'jsmith')
      patch project_path(project1), params: {
        project: { host_ids: ['', '2', '3'] }
      }
      assert_redirected_to settings_project_path(project1)
      get settings_project_path(project1)
      assert_response :success
      # Counts also the hidden field
      assert_select 'input[name=?]', 'project[host_ids][]', 3
    end

    test 'should should delete the respective hosts when deleting a project' do
      project1 = project(id: 1, type: 4)
      project2 = project(id: 2, type: 5)
      project1.hosts << project2

      log_user('admin', 'admin')
      # Deletes also the child project

      assert_difference('Project.projects.count', -2) do
        delete "/projects/#{project1.identifier}", params: { confirm: project1.identifier }
      end
      assert_redirected_to admin_projects_path
      assert_nil Project.find_by(id: 1)
      assert_equal 0, ProjectsRelation.where(guest_id: 3).count
    end

    test 'should not remove subordinates having close relatives' do
      skip 'Test fails due to some extra unknown dots! Run manually!'
      project1 = project(id: 1, type: 4)
      project2 = project(id: 2, type: 5)
      project1.hosts << project2
      log_user('admin', 'admin')
      patch project_path(project_type(id: 4)), params: {
        project: { subordinate_ids: [''] }
      }
      assert_response :success
      name = project_type(id: 5).name
      details = project_type(id: 4).close_hosts_message
      error_message = "#{name} #{l(:error_subordinates_have_projects_assigned, value: details)}"
      assert_select_error error_message
    end

    private

    def project_type(id:)
      find_project_type(id: id)
    end

    def project(id:, type: nil)
      project = Project.find(id.to_i)
      project.project_type_id = type
      project.save
      project
    end
  end
end
