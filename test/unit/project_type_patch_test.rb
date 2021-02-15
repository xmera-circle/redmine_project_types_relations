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

class ProjectTypePatchTest < ActiveSupport::TestCase
  include Redmine::I18n

  fixtures :projects, :members, :member_roles, :roles, :users,
           :project_types
 
  test 'should save subordinate relation' do
    project_type(id: 1).subordinates << [project_type(id: 2), project_type(id: 3)]
    assert_equal [2,3], project_type(id: 1).subordinate_ids

    assert_equal [1], project_type(id: 3).superordinate_ids
    assert_equal [project_type(id: 1)], project_type(id: 2).superordinates
  end
  
  test 'should not save itself as subordinate relation' do
    project_type1 = project_type(id: 1)
    begin
      project_type1.subordinates << project_type1
    rescue
    end
    assert_equal [l(:error_validate_self_relation)], project_type1.errors.messages[:project_type]
  end

  test 'should not save a superordinate as subordinate' do
    project_type1 = project_type(id: 1)
    project_type2 = project_type(id: 2)
    project_type1.subordinates << project_type2
    begin
      project_type2.subordinates << project_type1
    rescue
    end
    assert_equal [l(:error_validate_circular_reference)], project_type2.errors.messages[:project_type]
  end

  test 'should not change subordinates when they have host projects' do
    project_type1 = project_type(id: 1)
    project_type2 = project_type(id: 2)
    project1 = project(id: 1, type: 2)
    project_type1.subordinates << project_type2
    project_type2.projects << project1
    begin
      project_type1.subordinate_ids = []
    rescue
    end
    assert_equal [l(:error_subordinates_have_projects_assigned)], project_type1.errors.messages[:the_subordinate]
  end

  private

  def project_type(id:)
    ProjectType.find(id.to_i)
  end

  def project(id:, type: nil)
    project = Project.find(id.to_i)
    project.project_type_id = type
    project
  end
  
end
