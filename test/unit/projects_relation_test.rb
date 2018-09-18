require File.expand_path('../../test_helper', __FILE__)

class ProjectsRelationTest < ActiveSupport::TestCase
  # The fixtures method allows us to include fixtures from Redmine core's
  # test suite (for example, :issues, :roles, :users, :projects, and so on)
  fixtures :projects, :members, :member_roles, :roles, :users
  
  # plugin_fixtures: This is the method we monkey-patched into the various 
  # TestCase classes so that we could interact with Redmine's fixtures as 
  # well as our own custom fixtures.
  # The usage of plugin_fixtures requires some code in the plugins 
  # test_helper.rb
  #plugin_fixtures :project_types, :projects_project_types

  ProjectType::TestCase.create_fixtures(Redmine::Plugin.find(:project_types).directory + '/test/fixtures/', [:projects_project_types])
  ProjectsRelation::TestCase.create_fixtures(Redmine::Plugin.find(:project_types_relations).directory + '/test/fixtures/', [:project_types])
  
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
