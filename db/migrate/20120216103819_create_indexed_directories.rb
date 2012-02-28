class CreateIndexedDirectories < ActiveRecord::Migration
  def change
    create_table :indexed_directories do |t|
      t.string :name
      t.string :path
      t.integer :size, :default => 0
      t.references :parent
      t.references :device
      t.boolean :symboliclink, :default => false
      t.boolean :indexable, :default => true
      t.boolean :sortable, :default => false
      t.boolean :recursive, :default => false
      t.boolean :indexed, :default => false
      t.boolean :deleted, :default => false

      t.timestamps
    end
    add_index :indexed_directories, :parent_id
    add_index :indexed_directories, :device_id
  end
end
