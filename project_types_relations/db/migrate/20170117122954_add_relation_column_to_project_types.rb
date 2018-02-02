class AddRelationColumnToProjectTypes < ActiveRecord::Migration
  def up
    add_column :project_types, :related_to, :integer
  end
  
  def down
    remove_column :project_types, :related_to
  end
end
