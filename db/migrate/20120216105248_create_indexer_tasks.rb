class CreateIndexerTasks < ActiveRecord::Migration
  def change
    create_table :indexer_tasks do |t|
      t.string :name
      t.boolean :recursive, :default => false
      t.boolean :overwrite, :default => false
      t.integer :status, :default => 0
      t.references :device
      t.references :indexed_directory
      t.timestamps
    end
    add_index :indexer_tasks, :device_id
    add_index :indexer_tasks, :indexed_directory_id
  end
end
