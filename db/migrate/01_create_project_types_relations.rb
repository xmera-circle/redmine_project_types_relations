# frozen_string_literal: true

# Redmine plugin for xmera called Project Types Relations Plugin.
#
# Copyright (C) 2017-22 Liane Hampe <liaham@xmera.de>, xmera.
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

class CreateProjectTypesRelations < ActiveRecord::Migration[4.2]
  def self.up
    unless table_exists?(:project_types_relations)
      create_table :project_types_relations do |t|
        t.integer :superordinate_id, default: 0, null: false
        t.integer :subordinate_id, default: 0, null: false
      end
      unless index_exists?(:project_types_relations, %i[superordinate_id subordinate_id])
        add_index :project_types_relations, %i[superordinate_id subordinate_id],
                  name: 'unique_project_types_relations', unique: true
      end
    end
  end

  def self.down
    drop_table :project_types_relations if table_exists?(:project_types_relations)
  end
end
