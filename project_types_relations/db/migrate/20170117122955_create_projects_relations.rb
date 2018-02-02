class CreateProjectsRelations < ActiveRecord::Migration
  def change
    create_table :projects_relations do |t|
      t.integer :project_id, :default => 0, :null => false
      t.integer :related_project, :default => 0, :null => true
    end
  end
end
