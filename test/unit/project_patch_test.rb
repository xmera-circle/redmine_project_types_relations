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

class ProjectPatchTest < ActiveSupport::TestCase
  include Redmine::I18n
  extend RedmineProjectTypesRelations::LoadFixtures

  fixtures :projects, :members, :member_roles, :roles, :users,
    :project_types
 
  # test 'should have many hosts' do
  #   assert association = Project.reflect_on_association(:hosts)
  #   assert_equal :hosts, association.name
  #   assert_equal hosts_options, association&.options
  # end

  # test 'should have many projects_relations' do
  #   assert association = Project.reflect_on_association(:projects_relations)
  #   assert_equal :projects_relations, association.name
  #   assert_equal projects_relations_options, association&.options
  # end

  test 'should save guest and host relations of a project' do
    project(id: 1, type: 1).hosts << [project(id: 2, type: 2), project(id: 3, type: 2)]
    assert_equal [2,3], project(id: 1, type: 1).host_ids

    assert_equal [1], project(id: 3, type: 2).guest_ids
    assert_equal [project(id: 1, type: 1)], project(id: 2, type: 2).guests
  end

  test 'should find deprecated hosts before updating the project type of a project' do
    project_type(id: 1).subordinates << project_type(id: 2)
    project1 = project(id: 1, type: 1)
    project2 = project(id: 2, type: 2)
    project3 = project(id: 3, type: 2)
    project1.hosts << [project2, project3]
    assert project1.valid?
    project1.project_type_id = 3
    assert_not project1.valid?
    assert_equal [l(:error_project_has_invalid_host_projects)], project1.errors.messages[:project_type]
  end

  test 'should find guests before updating the project type of a project' do
    project_type(id: 1).subordinates << project_type(id: 2)
    project1 = project(id: 1, type: 1)
    project2 = project(id: 2, type: 2)
    project3 = project(id: 3, type: 2)
    project1.hosts << [project2]
    project2.hosts << [project3]
    assert project1.save! && project2.save!
    project2.project_type_id = 3
    assert_not project2.valid?
    assert_equal errors_for_existing_hosts_and_guests, project2.errors.messages[:project_type]
  end

  private

  def hosts_options
    Hash({ through: :projects_relations,
           source: :host,
           autosave: true })
  end

  def projects_relations_options
    Hash({ foreign_key: :guest_id })
  end

  def project(id:, type: nil)
    project = Project.find(id.to_i)
    project.project_type_id = type
    project
  end

  def project_type(id:)
    project = ProjectType.find(id.to_i)
  end

  def errors_for_existing_hosts_and_guests
    [l(:error_project_has_guest_projects), l(:error_project_has_invalid_host_projects)]
  end
  
end
