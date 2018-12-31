# Redmine plugin for xmera called Project Types Plugin.
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

module ProjectTypesRelations
  module Test
    module PluginPatch
       
       module ClassMethods
         # Allows to define dependent plugins within the
         # plugin register block
         Redmine::Plugin.def_field :dependencies
         # Finds the dependent plugins of a given plugin.
         # @param plugin_name [Symbol]
         # @return [Array] the dependent plugins names.
         def dependencies(plugin_name)
           plugin = find(plugin_name)
           plugin.dependencies.split(",")
         end
       end
       
       # Prepends the methods defined in Module ClassMethods
       # as class methods to the class Plugin.
       def self.prepended(mod)
         mod.singleton_class.prepend(ClassMethods)
       end
       
    end
  end   
end

# Apply patch
Rails.configuration.to_prepare do
  unless Redmine::Plugin.included_modules.include?(ProjectTypesRelations::Test::PluginPatch)
    Redmine::Plugin.prepend(ProjectTypesRelations::Test::PluginPatch)
  end
end