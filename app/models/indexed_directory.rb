class IndexedDirectory < ActiveRecord::Base

  belongs_to :parent, :class_name => "IndexedDirectory"
  belongs_to :device
  has_many :indexed_files, :foreign_key => "parent_id"
  has_many :indexed_directories, :foreign_key => "parent_id"

  # NOTA: Para que esto sea un scope, deberia devolver un ActiveRecord:Relation,
  # pero al devolver un solo 1 registro,  no es posible
  # Los metodos "IndexedDirectory." son asociados a la clase, no la instancia

  def IndexedDirectory.find_or_create_directory(name, parent_id, device_id)
    if name.empty?
      name = "/"
      parent_id = 0
    end
    where(:name => name, :parent_id => parent_id, :device_id => device_id).first_or_create(:indexed => false)
  end

  def IndexedDirectory.find_or_create_by_fullpath(device_id, fullpath)

    # Miramos si ya existe en el device algun indexed_directory con el fullpath
    indexeddirectory = find_all_by_device_id_and_path(device_id, fullpath)
    if !indexeddirectory == nil
      indexeddirectory
    else
      directories = fullpath.split("/")
      logger.info "Procesando ruta completa [#{fullpath}]"
      parent_id = -1
      directories.each do |x|
        logger.info "Procesando [#{x}]"
        indexeddirectory = find_or_create_directory(x, parent_id, device_id)
        parent_id = indexeddirectory.id
        logger.info "Directory [#{indexeddirectory.device_id}, #{indexeddirectory.id}, #{indexeddirectory.name}]"
      end
      indexeddirectory
    end
  end

  def fullpath
    if self.path == nil
      self.update_column(:path, calculatepath)
      #self.path = calculatepath
      #self.save
    end
    self.path
  end

  def calculatepath
    if self.name == "/"
      "/"
    else
      parent_fullpath = self.parent.fullpath
      if parent_fullpath == "/"
        parent_fullpath + self.name
      else
        parent_fullpath + "/" + self.name
      end
    end
  end

  def calculatesize
    self.size = IndexedDirectory.where(:parent_id => self.id).sum(:size) + IndexedFile.where(:parent_id => self.id).sum(:size)
    logger.info "Tamany del directorio #{self.name} = #{self.size}"
    self.save
  end

  def index(recursive = false, overwrite = false)
    self.go_to

    logger.info "Indexando #{self.device_id}: #{self.fullpath}, #{recursive}, #{overwrite}"

    if self.indexable?
      childsdirectories = []
      if self.indexed?
        if overwrite
          # Borrar los archivos que ya no existe
          self.refresh
          # Indexar contenido
          childsdirectories = self.index_content overwrite
        end
      else
        # Indexar contenido
        childsdirectories = self.index_content overwrite
      end

      if recursive
        # Indexar subdirectorios
        childsdirectories.each do |child_directory|
          child_directory.index recursive, overwrite
        end
      end

      self.update_column(:indexed, true)
      self.calculatesize
    end

    logger.info "Indexando #{self.device_id}: #{self.fullpath}, #{recursive} finalizado"

  end

  def index_content(overwrite = false)
    childsdirectories = []
    files_directory = Dir.glob("*")
    files_directory.each do |file|
      logger.info "Analizando content #{file}"
      if FileTest.directory?(file)
        childsdirectories << IndexedDirectory.find_or_create_directory(file, self.id, self.device_id)
      else
        size = FileTest.size(file)
        md5 = Digest::MD5.hexdigest(File.binread(file))
        indexedfile = IndexedFile.where(:name => file, :parent_id => self.id).first_or_create(:size => size, :md5 => md5)
        if !indexedfile.new_record? && overwrite
          logger.info "Actualizando info de #{file}"
          indexedfile.update_attributes(:size => size, :md5 => md5)
        end
      end
    end
    childsdirectories
  end

  # Marca como deleted los elementos que ya no estan en disco
  def refresh
    self.go_to
    resources = Dir.glob("*")
    directories = resources.select { |x| FileTest.directory?(x) }
    self.indexed_directories.each { |indexed_directory|
      logger.info "Analizando #{indexed_directory.name} en posicion #{directories.index(indexed_directory.name)}"
      if !directories.index(indexed_directory.name) && !indexed_directory.deleted?
        logger.info "Borrando #{indexed_directory.name}"
        indexed_directory.update_column(:deleted, true)
      end
    }
    files = resources - directories
    self.indexed_files.each { |indexed_file|
      logger.info "Analizando #{indexed_file.name} en posicion #{files.index(indexed_file.name)}"
      unless files.index(indexed_file.name)
        logger.info "Borrando #{indexed_file.name}"
        indexed_file.update_column(:deleted, true)
      end
    }
  end

  def go_to
    Dir.chdir(self.device.name + "/" + self.fullpath)
  end


end
