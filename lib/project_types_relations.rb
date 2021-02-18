# frozen_string_literal: true

# Redmine plugin for xmera called Project Types Relations Plugin.
#
# Copyright (C) 2017-21 Liane Hampe <liaham@xmera.de>, xmera.
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

# Relations
require 'project_types_relations/relations/subordinated_project_types'
require 'project_types_relations/relations/host_projects'
require 'project_types_relations/relations/enable'

# Patches
require 'project_types_relations/patches/project_patch'
require 'project_types_relations/patches/project_type_patch'

# Hooks
require 'project_types_relations/hooks/view_projects_form_hook_listener'
require 'project_types_relations/hooks/view_layouts_base_html_head_hook_listener'
require 'project_types_relations/hooks/view_projects_show_right_hook_listener'
require 'project_types_relations/hooks/view_project_types_form_top_of_associates_hook_listener'
require 'project_types_relations/hooks/view_project_types_table_header_hook_listener'
require 'project_types_relations/hooks/view_project_types_table_data_hook_listener'

# Association
require 'project_types_relations/associations/subordinated_project_types'
require 'project_types_relations/associations/host_projects'
