class CreateIndexerOptions < ActiveRecord::Migration
  def change
    create_table :indexer_options do |t|
      t.boolean :auto_analyze, :default => false
      t.boolean :auto_indexer, :default => false
      t.boolean :overwrite, :default => false
      t.boolean :recursive, :default => false
      t.integer :recursive_level, :default => 0
      t.boolean :refresh_parent, :default => true
      t.boolean :show_unindexed, :default => true
    end
  end
end
