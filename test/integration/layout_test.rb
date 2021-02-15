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

require File.expand_path('../../test_helper', __FILE__)
# Considers a namespace for LayoutTest since it might get superclass mismatches when using 
# the class name more than once.
class LayoutTest < Redmine::IntegrationTest
  include Redmine::I18n
  include RedmineProjectTypesRelations::LoadFixtures
  include RedmineProjectTypesRelations::AuthenticateUser
  include RedmineProjectTypesRelations::CreateProjectType

  fixtures :projects, :trackers, :issue_statuses, :issues,
           :enumerations, :users, :issue_categories,
           :projects_trackers,
           :roles, :member_roles, :members, :enabled_modules,
           :project_types 

  
  # def test_existence_of_project_type_in_project_overview
  #   project(id: 1, type: 1)
  #   log_user('jsmith', 'jsmith')
  #   get project_path(id: 1)
  #   assert_response :success
  #   assert_select 'td.name', 'name1'
  # end


  # def test_existence_of_assigned_project_list_in_project_overview
  #   project_type1 = ProjectType.find(1)
  #   project_type2 = ProjectType.find(2)
  #   project_type2.subordinates << project_type1
  #   project1 = project(id: 1, type: 1)
  #   project2 = project(id: 2, type: 2)
  #   log_user('jsmith', 'jsmith')
  #   get project_path(project2)
  #   assert_response :success
  #   assert_select 'h3', l(:label_assigned_project_plural)
  # end
  
   def test_existence_of_host_checkboxes_in_project_settings
    project1 = project(id: 3, type: 1)
    log_user('admin', 'admin')
    get settings_project_path(project1)
    assert_response :success
    assert_select "input[type=checkbox][name='project[host_ids][]']"
  end
  
  def test_existence_of_subordinated_project_types
    project_type = ProjectType.find(1)
    log_user('admin', 'admin')
    get edit_project_type_path(project_type)
    assert_response :success
    assert_select "#subordinated_project_types", 1
  end
  
  def test_existence_of_host_projects_in_project_types_index
    project_type = ProjectType.find(1)
    log_user('admin', 'admin')
    get project_types_path
    assert_response :success
    assert_select ".relation", 3
  end
  
  private

  def project(id:, type: nil)
    project = Project.find(id.to_i)
    project.project_type_id = type
    project
  end
  
  
end