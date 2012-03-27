class CreateStatusTasks < ActiveRecord::Migration
  def change
    create_table :status_tasks do |t|
      t.string :name
    end
  end
end
