class Device < ActiveRecord::Base
  has_many :indexer_tasks
  has_many :indexed_directories

  FILEKEY_NAME = "filename.key"
  UUID_ERROR = :device_not_writable

  before_create :create_filekey

  # @return [IndexedDirectory]
  def find_root
    IndexedDirectory.find_by_name_and_device_id(IndexedDirectory::ROOT_NAME, self.id)
    #self.indexed_directories.select { |directory| directory.name == "/" }
  end

  def create_filekey
    f = File.open(self.name + IndexedDirectory::ROOT_NAME + FILEKEY_NAME, "w")
    uuid = SecureRandom.uuid
    f.write(uuid)
    f.close
    self.uuid = uuid
  rescue Exception
    self.uuid = UUID_ERROR
  end

  def read_filekey
    f = File.open(self.name + IndexedDirectory::ROOT_NAME + FILEKEY_NAME, "r")
    uuid_file = f.readline
    f.close
    uuid_file
  rescue Exception
    logger.error "Error al recuperar el archivo #{FILEKEY_NAME}"
    nil
  end

  def validate_filekey?
     if self.uuid == nil
       false
     else
       self.read_filekey == self.uuid
     end
  end
end
