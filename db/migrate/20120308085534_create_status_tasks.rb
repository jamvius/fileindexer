class CreateStatusTasks < ActiveRecord::Migration
  def change
    create_table :status_tasks do |t|
      t.string :name

      t.timestamps
    end
  end
end
