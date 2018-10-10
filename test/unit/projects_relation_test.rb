# Redmine plugin for xmera:isms called Project Types Relations Plugin
#
# Copyright (C) 2017-18 Liane Hampe <liane.hampe@xmera.de>
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

class ProjectsRelationTest < ProjectTypesRelations::Test::UnitTest
  
  fixtures :projects, :members, :member_roles, :roles, :users, :projects_project_types, :project_types

  test "should save a related project where project types are well related" do
     projects_relation = ProjectsRelation.new(project_id: 1, related_project: 3)
     assert projects_relation.save
  end
  
  test "should not save a related project where project types are non related" do
     projects_relation = ProjectsRelation.new(project_id: 1, related_project: 2)
     assert !projects_relation.save
  end
  
  test "should not save a related project where the leading project has no project type" do
     projects_relation = ProjectsRelation.new(project_id: 5, related_project: 1)
     assert !projects_relation.save
  end
  
  test "should not save a related project where both the leading project and the choosen one have no project type" do
     projects_relation = ProjectsRelation.new(project_id: 5, related_project: 4)
     assert !projects_relation.save
  end
end
