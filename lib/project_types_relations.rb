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

# Project Types Relations Libraries

# Plugins patches
require 'project_types_relations/patches/project_patch'
require 'project_types_relations/patches/project_type_patch'
require 'project_types_relations/patches/projects_project_type_patch'
require 'project_types_relations/patches/projects_controller_patch'
require 'project_types_relations/patches/project_types_controller_patch'

# Plugins hook listener
require 'project_types_relations/hooks/view_projects_form_hook_listener'
require 'project_types_relations/hooks/view_projects_show_right_hook_listener'
require 'project_types_relations/hooks/view_project_types_form_middle_hook_listener'
require 'project_types_relations/hooks/view_project_types_table_header_hook_listener'
require 'project_types_relations/hooks/view_project_types_table_data_hook_listener'
