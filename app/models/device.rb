class Device < ActiveRecord::Base
  has_many :indexer_tasks
end
