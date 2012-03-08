class IndexerTask < ActiveRecord::Base
  belongs_to :device
  belongs_to :indexed_directory
  belongs_to :status_task

  before_create :add_directory

  def add_directory
    logger.info "start add_directory for #{self.name}"
    indexeddirectory = IndexedDirectory.find_or_create_by_fullpath(self.device_id, self.name)
    logger.info "Directorio encontrado #{indexed_directory}"
    self.indexed_directory_id = indexeddirectory.id
  end

  def run
    logger.info("Indexando #{self.name} -> status #{self.status_task.name}")
    if self.status_task == StatusTask.PENDING
      self.update_column(:status_task_id, StatusTask.RUNNING)
      self.indexed_directory.index(self.recursive,self.overwrite)
      self.update_column(:status_task_id, StatusTask.FINNISH)
    else
      logger.info("Task ya procesada")
    end
  end

end
