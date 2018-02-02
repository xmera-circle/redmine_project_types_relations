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

class ProjectsControllerPatchTest < ActionController::TestCase

 fixtures :projects, :members, :member_roles, :roles, :users

 #plugin_fixtures :project_types, :projects_project_types
 
 ProjectType::TestCase.create_fixtures(Redmine::Plugin.find(:project_types).directory + '/test/fixtures/', [])
 ProjectsRelation::TestCase.create_fixtures(Redmine::Plugin.find(:project_types_relations).directory + '/test/fixtures/', [:projects_relations])
 # Default setting
 def setup
   @controller = ProjectsController.new
   @request.session[:user_id] = nil
   Setting.default_language = 'en'
 end

 test "new projects should not display the relation to field" do
   @request.session[:user_id] = 1 # admin
   get :new
   assert_response :success
   assert_select '#projects_relation_related_project_', false
 end
 
 test "projects settings should display the relation to field" do
   @request.session[:user_id] = 1 # admin
   get :settings, :id => 1
   assert_response :success
   assert_select '#projects_relation_related_project_'
 end
 
 test "no relation choice set should be displayed when no project type is chosen" do
   @request.session[:user_id] = 1 # admin
   get :settings, :id => 4
   assert_response :success
   assert_select '#projects_relation_related_project_', false
   assert_select "label", {count: 1, text: "Related to"}   
 end

 test "no relation choice set should be displayed when there is no relation with the project type" do
   @request.session[:user_id] = 1 # admin
   get :settings, :id => 5
   assert_response :success
   assert_select '#projects_relation_related_project_', false
   assert_select "label", {count: 1, text: "Related to"}  
 end
 
 test "should show the relation choice set when the chosen project type has a relation" do
   @request.session[:user_id] = 1 # admin
   get :settings, :id => 1
   assert_response :success
   assert_select 'input[name=?]', 'projects_relation[related_project][]', 2
 end
 
 test "update displayed choice set when project type selection is changed" do
   @request.session[:user_id] = 1 # admin
   post :update, :id => 1, project: { 
                  projects_project_type_attributes: { id: 1,
                             project_type_id: nil        
                           }}
   assert_redirected_to '/projects/ecookbook/settings'
   get :settings, :id => 1
   assert_response :success
   assert_select 'input[name=?]', 'projects_relation[related_project][]', 0 
   assert_select "label", {count: 1, text: "Related to"}  
 end
 
 test "update existing projects relations" do
   @request.session[:user_id] = 1 # admin
   post :update, :id => 1, project: { 
                  projects_project_type_attributes: { id: 1,
                             project_type_id: 1        
                           }}
   assert_redirected_to '/projects/ecookbook/settings'
   get :settings, :id => 1
   assert_response :success
   assert_select 'input[name=?]', 'projects_relation[related_project][]', 2 
 end
 
 test "create a new projects relation" do
   @request.session[:user_id] = 1 # admin
   assert_difference('ProjectsRelation.count',1) do
     patch :update, :id => 1, project: {name: 'eCookbook', identifier: 'ecookbook'},
                             projects_relation: {project_id: 1, related_project: ['','3']}
     assert_redirected_to '/projects/ecookbook/settings'
   end
   get :settings, :id => 1
   assert_response :success
   assert_select 'input[name=?][value=?]', 'projects_relation[related_project][]', '3', 1
 end
 
 test "update project type should delete the projects relations" do
   @request.session[:user_id] = 1 # admin
   assert_difference('ProjectsRelation.count',1) do
     patch :update, :id => 1, project: {name: 'eCookbook', identifier: 'ecookbook',
                                        projects_project_type_attributes: {id: 1, project_type_id: 1}},
                              projects_relation: {project_id: 1, related_project: ['','3']}
     assert_redirected_to '/projects/ecookbook/settings'
   end
   assert_difference('ProjectsRelation.count',-1) do
     patch :update, :id => 1, project: {name: 'eCookbook', identifier: 'ecookbook',
                                        projects_project_type_attributes: {id: 1, project_type_id: nil}},
                              projects_relation: {project_id: 1, related_project: ['','3']}                      
     assert_redirected_to '/projects/ecookbook/settings'
   end
   get :settings, :id => 1
   assert_response :success
   assert_select 'input[name=?]', 'projects_relation[related_project][]', 0
 end
 
 test "delete a project should delete the respective projects relations" do
   @request.session[:user_id] = 1 # admin
   assert_equal 1, ProjectsRelation.where(project_id: 3).count
   assert_difference('Project.count',-1) do
     delete :destroy, :id => 3, :confirm => 1
     assert_redirected_to admin_projects_path #'/admin/projects'
   end
   assert_nil Project.find_by(id: 3)
   assert_equal 0, ProjectsRelation.where(project_id: 3).count, "projects relation still exists"
 end


end