class CreateIndexedDirectories < ActiveRecord::Migration
  def change
    create_table :indexed_directories do |t|
      t.string :name
      t.string :path
      t.references :parent
      t.references :device

      # Directory Options
      t.boolean :symboliclink, :default => false
      t.boolean :indexable, :default => true
      t.boolean :sortable, :default => false
      t.boolean :recursive, :default => true

      # Status directory
      t.boolean :indexed, :default => false
      t.boolean :analyzed, :default => false
      t.boolean :deleted, :default => false

      # Summary directory
      t.integer :numfiles, :default => 0
      t.integer :numdirectories, :default => 0
      t.integer :size, :default => 0, :limit => 8

      # Summary childrens
      t.integer :recursive_size, :default => 0, :limit => 8
      t.boolean :recursive_indexed, :default => false
      t.boolean :recursive_analyzed, :default => false
      t.integer :recursive_numfiles, :default => 0
      t.integer :recursive_numdirectories, :default => 0

      t.timestamps
    end
    add_index :indexed_directories, :parent_id
    add_index :indexed_directories, :device_id
  end
end
