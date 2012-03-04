class IndexerTask < ActiveRecord::Base
  belongs_to :device
  belongs_to :indexed_directory

  before_create :add_directory

  def add_directory
    logger.info "start add_directory for #{self.name}"
    indexeddirectory = IndexedDirectory.find_or_create_by_fullpath(self.device_id, self.name)
    logger.info "Directorio encontrado #{indexed_directory}"
    self.indexed_directory_id = indexeddirectory.id
  end

  def run
    logger.info("Indexando #{self.name} -> status #{self.status}")
    if self.status == 0
      self.update_column(:status, 1)
      self.indexed_directory.index(self.recursive,self.overwrite)
      self.update_column(:status, 2)
    else
      logger.info("Task ya procesada")
    end
  end

end
