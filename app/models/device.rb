class Device < ActiveRecord::Base
  has_many :indexer_tasks
  has_many :indexed_directories

  # @return [IndexedDirectory]
  def find_root
    IndexedDirectory.find_by_name_and_device_id(IndexedDirectory::ROOT_NAME, self.id)
    #self.indexed_directories.select { |directory| directory.name == "/" }
  end
end
