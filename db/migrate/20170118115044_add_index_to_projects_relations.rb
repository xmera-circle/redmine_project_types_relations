class AddIndexToProjectsRelations < ActiveRecord::Migration
  def change
    add_index :projects_relations, :project_id
  end
end
