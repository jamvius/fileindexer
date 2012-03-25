require "modules/directory_helper"

class IndexedDirectory < ActiveRecord::Base
  include DirectoryHelper

  belongs_to :parent, :class_name => "IndexedDirectory"
  belongs_to :device
  has_many :indexed_files, :foreign_key => "parent_id"
  has_many :indexed_directories, :foreign_key => "parent_id"

  ROOT_NAME = "/"

  # NOTA: Para que esto sea un scope, deberia devolver un ActiveRecord:Relation,
  # pero al devolver un solo 1 registro,  no es posible
  # Los metodos "IndexedDirectory." son asociados a la clase, no la instancia

  def IndexedDirectory.find_or_create_directory(name, parent_id, device_id)
    if name.empty?
      name = ROOT_NAME
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
    end
    self.path
  end

  def calculatepath
    if self.name == ROOT_NAME
      ROOT_NAME
    else
      parent_fullpath = self.parent.fullpath
      if parent_fullpath == ROOT_NAME
        parent_fullpath + self.name
      else
        parent_fullpath + "/" + self.name
      end
    end
  end

  def index(recursive = false, overwrite = false, recursive_level = 0)
    self.go_to

    logger.info "Indexando #{self.device_id}: #{self.fullpath}, #{recursive}, #{overwrite}"

    if self.indexable?
      if self.indexed? && overwrite
          # Borrar los archivos que ya no existe
          self.refresh
      end
      # Indexar contenido
      childsdirectories = self.index_content overwrite

      if (recursive or recursive_level > 0) and self.recursive
        logger.info "Flag recursive, recorremos los hijos #{childsdirectories}"
        # Indexar subdirectorios
        childsdirectories.each do |child_directory|
          child_directory.index recursive, overwrite, recursive_level - 1
        end
      end

      self.update_stats(true)
    end

    logger.info "Indexando #{self.device_id}: #{self.fullpath}, #{recursive} finalizado"

  end

  def update_stats(indexed = false, recursive = false)
    if recursive
      self.indexed_directories.each {|directory| directory.update_stats(recursive)}
    end

    logger.info "Stats size: #{self.size}, #{self.indexed?}"
    new_size = self.indexed_directories.inject(0) { |total, directory| total + directory.size }
    new_size = self.indexed_files.inject(new_size) { |total, file| total + file.size }

    childs_indexed = self.indexed_directories.all? { |directory| directory.recursive_indexed? }

    num_files = self.indexed_directories.inject(self.indexed_files.size) { |total, directory|
      total + directory.recursive_numfiles
    }
    num_directories = self.indexed_directories.inject(self.indexed_directories.size) { |total, directory|
      total + directory.recursive_numdirectories
    }

    self.indexed = indexed if indexed

    logger.info "Actualizando stats size: #{new_size}, #{childs_indexed} + #{self.indexed?}"
    self.update_attributes(:size => new_size, :recursive_indexed => childs_indexed, :recursive_numfiles => num_files, :recursive_numdirectories => num_directories)

  end

  def index_content(overwrite = false)
    childsdirectories = []
    files_directory = Dir.glob("*")
    logger.info "archivos encontrado #{files_directory}"
    files_directory.each do |file|
      logger.info "Analizando content #{file}"
      if FileTest.directory?(file)
        childsdirectories << IndexedDirectory.find_or_create_directory(file, self.id, self.device_id)
      else
        size = FileTest.size(file)
        # Comento el md5 por temas de rendimiento
        #if size > 1024*1024*10
        #  md5 = "aaaaafffff"
        #else
        #  md5 = Digest::MD5.hexdigest(File.binread(file))
        #end

        indexedfile = IndexedFile.where(:name => file, :parent_id => self.id).first_or_create(:size => size)
        if !indexedfile.new_record? && overwrite
          logger.info "Actualizando info de #{file}"
          indexedfile.update_attributes(:size => size)
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

  def hierarchy
    path = []
    actual_dir = self
    while actual_dir.name != ROOT_NAME do
      logger.info "Estamos en #{actual_dir.name}"
      path.unshift(actual_dir.parent)
      actual_dir = actual_dir.parent
    end
    path
  end

end
