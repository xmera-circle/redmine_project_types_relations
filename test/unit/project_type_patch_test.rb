# Redmine plugin for xmera called Project Types Relations Plugin.
#
# Copyright (C) 2017-19 Liane Hampe <liane.hampe@xmera.de>.
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

class ProjectTypePatchTest < ProjectTypesRelations::Test::UnitTest

 fixtures :projects, :members, :member_roles, :roles, :users, :projects_project_types, :project_types
 
  test "should not save double assigned project types" do
    projecttype0 = ProjectType.new(:name => "ZeroProjectType")
    projecttype0.save
    projecttype1 = ProjectType.new(:name => "FirstProjectType", :related_to => projecttype0.id)
    projecttype1.save
    projecttype2 = ProjectType.new(:name => "SecondProjectType", :related_to => projecttype0.id)
    assert !projecttype2.save, "Saved the project type with an already existing project type relation."
  end
  
  test "should not save a relation to itself" do
    projecttype0 = ProjectType.new(:name => "ZeroProjectType")
    projecttype0.save
    assert !projecttype0.update(:related_to => projecttype0.id)
  end
  
  test "should not save a relation which is not a project type" do
    projecttype0 = ProjectType.new(:name => "ZeroProjectType", :related_to => 99)
    assert !projecttype0.save
  end
  
end
