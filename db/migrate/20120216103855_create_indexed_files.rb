class CreateIndexedFiles < ActiveRecord::Migration
  def change
    create_table :indexed_files do |t|
      t.string :name
      t.integer :size, :default => 0, :limit => 8
      t.string :md5
      t.references :parent
      t.boolean :symboliclink, :default => false
      t.boolean :deleted, :default => false

      t.timestamps
    end
    add_index :indexed_files, :parent_id
  end
end
