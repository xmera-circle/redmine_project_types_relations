# Redmine plugin for xmera:isms called Custom Footer Plugin
#
#  Copyright (C) 2017-18 Liane Hampe <liane.hampe@xmera.de>
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
class ProjectTypesRelations::LayoutTest < ProjectTypesRelations::Test::IntegrationTest
  include Redmine::I18n
  fixtures :projects, :trackers, :issue_statuses, :issues,
           :enumerations, :users, :issue_categories,
           :projects_trackers,
           :roles,
           :member_roles,
           :members,
           :enabled_modules,
           :projects_project_types,
           :project_types,
           :projects_relations
  
  def test_existence_of_assigned_project_in_project_overview
    log_user('jsmith', 'jsmith')
    project = Project.find(3)
    get project_path(project)
    assert_response :success
    assert_select '.projects.box a','Private child of eCookbook'
  end
  
   def test_existence_of_related_projects_in_project_settings
    log_user('admin', 'admin')
    project = Project.find(3)
    get settings_project_path(project)
    assert_response :success
    assert_select "input[type=checkbox][name='projects_relation[related_project][]']"
  end
  
  def test_existence_of_related_projects_in_project_types
    log_user('admin', 'admin')
    project_type = ProjectType.find(1)
    get edit_project_type_path(project_type)
    assert_response :success
    assert_select "#project_type_related_to", 1
  end
  
    def test_existence_of_related_projects_in_project_types_index
    log_user('admin', 'admin')
    project_type = ProjectType.find(1)
    get project_types_path
    assert_response :success
    assert_select ".relation", 3
  end
  
  
  
end