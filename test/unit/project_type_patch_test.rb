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

module ProjectTypesRelations
  class ProjectTypePatchTest < ActiveSupport::TestCase
    include Redmine::I18n
    extend ProjectTypesRelations::LoadFixtures
    include ProjectTypesRelations::ProjectTypeCreator

    fixtures :projects, :members, :member_roles, :roles, :users

    test 'should save subordinate relation' do
      project_type1 = project_type(id: 1)
      project_type2 = project_type(id: 2)
      project_type3 = project_type(id: 3)
      project_type1.subordinates << [project_type2, project_type3]
      assert_equal [2, 3], project_type1.subordinate_ids

      assert_equal [1], project_type3.superordinate_ids
      assert_equal [project_type1], project_type2.superordinates
    end

    test 'should not save itself as subordinate relation' do
      project_type1 = project_type(id: 1)
      begin
        project_type1.subordinates << project_type1
      rescue ActiveRecord::RecordInvalid
        return false
      end
      assert_equal [l(:error_validate_self_relation)], project_type1.errors.messages[:project_type]
    end

    test 'should not save a superordinate as subordinate' do
      project_type1 = project_type(id: 1)
      project_type2 = project_type(id: 2)
      project_type1.subordinates << project_type2
      begin
        project_type2.subordinates << project_type1
      rescue ActiveRecord::RecordInvalid
        return false
      end
      assert_equal [l(:error_validate_circular_reference)], project_type2.errors.messages[:project_type]
    end

    test 'should not change subordinates when they have host projects' do
  skip 'Rewrite test as functional'
      project_type1 = project_type(id: 1)
      project_type2 = project_type(id: 2)
      project3 = project(id: 3, type: 2)
      project4 = project(id: 4, type: 1)
      project_type1.subordinates << project_type2
      project_type1.relatives << project4
      project_type2.relatives << project3
      # Set the relation between two projects which binds the project types to 
      # each other
      project4.hosts << project3
      byebug
      begin
        project_type1.subordinate_ids = []
      rescue ActiveRecord::RecordInvalid
        return false
      end
      assert_equal [l(:error_subordinates_have_projects_assigned, count: 1)],
                   project_type1.errors.messages[:the_subordinate]
    end

    test 'should have extended safe_attribute_names' do
      assert_equal [], project_type(id: 1).safe_attribute_names - safe_attribute_names
      assert_equal [], safe_attribute_names - project_type(id: 1).safe_attribute_names
    end

    private

    def project_type(id:)
      find_project_type(id: id)
    end

    def project(id:, type: nil)
      project = Project.find(id.to_i)
      project.project_type_id = type
      project
    end
    
    ##
    # Enabled module names are disabled when the user is not allowed to 
    # select project module. In this test the current user is anonymous.
    #
    def safe_attribute_names
      %w[name
         description
         identifier
         is_public
         homepage
         parent_id
         default_version_id
         inherit_members
         project_type_id
         is_project_type
         default_assigned_to_id
         tracker_ids
         custom_field_values
         custom_fields
         issue_custom_field_ids
         project_custom_field_ids
         subordinate_ids
         host_ids]
    end
  end
end
