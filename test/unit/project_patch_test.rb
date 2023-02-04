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
  class ProjectPatchTest < ActiveSupport::TestCase
    include Redmine::I18n
    extend ProjectTypesRelations::LoadFixtures
    include ProjectTypesRelations::ProjectTypeCreator

    fixtures :projects, :members, :member_roles, :roles, :users

    def setup
      project_type(id: 4).subordinates << project_type(id: 5)
      project_type(id: 6)
    end

    test 'should save guest and host relations of a project' do
      project1 = project(id: 1, type: 4)
      project2 = project(id: 2, type: 5)
      project1.hosts << project2
      project1.reload
      project2.reload

      assert_equal [2], project1.host_ids
      assert_equal [project2], project1.hosts
      assert_equal [1], project2.guest_ids
      assert_equal [project1], project2.guests
    end

    test 'should find deprecated hosts before updating the project type of a project' do
      project1 = project(id: 1, type: 4)
      project2 = project(id: 2, type: 5)

      project1.hosts << project2
      assert project1.valid?

      project1.project_type_id = 6
      assert_not project1.valid?
      expected_error_message = [l(:error_deprecated_host_projects, count: 1)]
      assert_equal expected_error_message, project1.errors.messages[:project_type_id]
    end

    test 'should find guests before updating the project type of a project' do
      project_type(id: 5).subordinates << project_type(id: 6)
      project1 = project(id: 1, type: 4)
      project2 = project(id: 2, type: 5)

      project1.hosts << [project2]
      assert project1.valid?

      project2.project_type_id = 6
      assert_not project2.valid?
      expected_error_messages = [l(:error_lost_guest_projects, count: 1)]
      assert_equal expected_error_messages, project2.errors.messages[:project_type_id]
    end

    test 'should find hosts and guests before updating the project type of a project' do
      project_type(id: 5).subordinates << project_type(id: 6)
      project1 = project(id: 1, type: 4)
      project2 = project(id: 2, type: 5)
      project3 = project(id: 3, type: 6)

      project1.hosts << [project2]
      project2.hosts << [project3]
      assert project1.valid? && project2.valid?

      project2.project_type_id = 6
      assert_not project2.valid?
      expected_error_messages = [l(:error_deprecated_host_projects, count: 1),
                                 l(:error_lost_guest_projects, count: 1)]
      assert_equal expected_error_messages, project2.errors.messages[:project_type_id]
    end

    private

    def hosts_options
      Hash({ through: :projects_relations,
             source: :host,
             autosave: true })
    end

    def projects_relations_options
      Hash({ foreign_key: :guest_id,
             dependent: :destroy })
    end

    def project(id:, type: nil)
      project = Project.find(id.to_i)
      project.project_type_id = type
      project.save
      project
    end

    def project_type(id:)
      find_project_type(id: id)
    end
  end
end
