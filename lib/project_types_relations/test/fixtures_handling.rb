# Redmine plugin for xmera called Project Types Relations Plugin.
#
# Copyright (C) 2017-19 Liane Hampe <liane.hampe@xmera.de>
#
# The code below is taken from:
#
# Copyright © 2011    Vít Jonáš <vit.jonas@gmail.com>
# Copyright © 2012    Daniel Munn <dan.munn@munnster.co.uk>
# Copyright © 2011-15 Karel Pičman <karel.picman@kontron.com>
#
# and extended by Liane Hampe. 
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
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

module ProjectTypesRelations
  module Test
    module FixturesHandling
      # Allow us to override the fixtures method of ActiveSupport::TestCase 
      # to implement fixtures for our plugin and its dependencies.
      # Ultimately it allows for better integration without blowing redmine fixtures up,
      # and allowing us to supplement redmine fixtures if we need to.
      #
      # @param table_names [Symbol] A comma separated list of table names for which there
      #   is a fixtures file with the same name.
      # @note The method requires the PluginPatch (lib/patches/plugin_patch.rb) where 
      #   dependencies are defined and the repective definition when registering 
      #   the plugin in init.rb.
      def fixtures(*table_names)
        # Allows to create fixtures for each test case independent of previously defined
        # fixtures in other test cases with the same names.
        # This is especially helpful when running tests successively 
        # as with 'redmine:plugins:test'.
        ActiveRecord::FixtureSet.reset_cache
        
        dir = File.join( File.dirname(__FILE__), '../../../test/fixtures')
        #dir = File.join(Redmine::Plugin.directory, 'xmera_ms/plugins/project_types_relations/test/fixtures')
        dependencies = Redmine::Plugin.dependencies(:project_types_relations)
        # Gives an array of dirs of dependent plugins which are installed
        dep_dirs =  dependencies.map do |dependent|
                      if Redmine::Plugin.installed?(dependent)
                        #File.join(Redmine::Plugin.directory,"#{dependent}/test/fixtures")
                        File.join(File.dirname(__FILE__),"../../../../#{dependent}/test/fixtures")
                      end
                    end.compact
        # Creates the fixtures of the plugin and its dependencies as long as there are fixture files.
        # The order of creation is:
        #   - first: fixtures of current plugin
        #   - second:fixtures of plugins dependencies
        #   - third: fixtures of Redmine core
        table_names.each do |name|
          dep_dirs.each do |dep_dir|
            if File.exist?("#{dir}/#{name}.yml")  
              ActiveRecord::FixtureSet.create_fixtures(dir, name)          
            else
              ActiveRecord::FixtureSet.create_fixtures(dep_dir, name) if  File.exist?("#{dep_dir}/#{name}.yml")
            end
          end
        end
        super(table_names)
      end
    end
  end  
end