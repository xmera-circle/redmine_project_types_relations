require File.expand_path('../../test_helper', __FILE__)

class ProjectTypePatchTest < ActiveSupport::TestCase

 fixtures :projects, :members, :member_roles, :roles, :users

 #plugin_fixtures :project_types, :projects_project_types
 
 ProjectsRelation::TestCase.create_fixtures(Redmine::Plugin.find(:project_types).directory + '/test/fixtures/', [:project_types, :projects_project_types])
 
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
