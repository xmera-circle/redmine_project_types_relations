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

require_dependency 'project_types_relations'

Redmine::Plugin.register :project_types_relations do
  name 'Project Types Relations Plugin'
  author 'Liane Hampe'
  description 'This is a plugin for setting project types in relation to each other.'
  version '0.2.2'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about' 
  # The attribute dependencies comes from lib/test/plugin_path.rb and is necessary
  # for testing purposes.
  dependencies 'project_types'
  
  # Redmine version dependency
  requires_redmine version_or_higher: '3.3.2'

  # Plugin dependencies - Note: Take care of the alphabetical loading order of plugins
  begin
    requires_redmine_plugin :project_types, :version_or_higher => '0.1.0'
  rescue Redmine::PluginNotFound => e
    raise e.message + ": Please install Project Types Plugin"
  end
end

# Sends helper files directly into ProjectsController
ActionDispatch::Callbacks.to_prepare do
  ProjectsController.send :helper, ProjectsRelationsHelper unless ProjectsController.included_modules.include? ProjectsRelationsHelper
end
