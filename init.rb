require 'redmine'

# Patches to the Redmine core or dependent plugins
require 'project_type_patch'
require 'project_types_controller_patch'
require File.expand_path(File.dirname(__FILE__) + '/app/helpers/projects_relations_helper')
require 'projects_relations_projects_controller_patch'
require 'projects_project_type_patch'
require 'projects_relations_project_patch'

ActionDispatch::Callbacks.to_prepare do
  ProjectType.send :include, ProjectTypePatch unless ProjectType.included_modules.include? ProjectTypePatch
  ProjectTypesController.send :include, ProjectTypesControllerPatch unless ProjectTypesController.included_modules.include? ProjectTypesControllerPatch
  ProjectsController.send :helper, ProjectsRelationsHelper unless ProjectsController.included_modules.include? ProjectsRelationsHelper
  ProjectsController.send :prepend, ProjectsRelationsProjectsControllerPatch unless ProjectsController.included_modules.include? ProjectsRelationsProjectsControllerPatch
  ProjectsProjectType.send :include, ProjectsProjectTypePatch unless ProjectsProjectType.included_modules.include? ProjectsProjectTypePatch
  Project.send :include, ProjectsRelationsProjectPatch unless Project.included_modules.include? ProjectsRelationsProjectPatch
end

# Plugin registration
Redmine::Plugin.register :project_types_relations do
  name 'Project Types Relations Plugin'
  author 'Liane Hampe'
  description 'This is a plugin for setting project types in relation to each other.'
  version '0.1.3'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'
  
  # Redmine version dependency
  requires_redmine '3.3.2'

  # Plugin dependencies - Note: Take care of the alphabetical loading order of plugins
  begin
    requires_redmine_plugin :project_types, :version_or_higher => '0.1.0'
  rescue Redmine::PluginNotFound => e
    raise "Please install Project Types Plugin"
  end
end

require_dependency 'project_relations_hook_listener'

