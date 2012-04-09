require "modules/directory_helper"
require "modules/analyzer_directory"
require "modules/indexer_directory"
require "modules/status_directory"

class IndexedDirectory < ActiveRecord::Base
  include DirectoryHelper
  include AnalyzerDirectory
  include IndexerDirectory
  include StatusDirectory

  belongs_to :parent, :class_name => "IndexedDirectory"
  belongs_to :device
  has_many :indexed_files, :foreign_key => "parent_id"
  has_many :indexed_directories, :foreign_key => "parent_id"

  ROOT_NAME = "/"

  def partial_indexed?
    !self.indexed? and (indexed_directories.size > 0 or indexed_files.size > 0)
  end

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

  def update_parents
    actual_dir = self.parent
    until actual_dir.nil? do
      actual_dir.go_to
      actual_dir.analyze_status
      actual_dir.index_status
      actual_dir.save
      actual_dir = actual_dir.parent
    end

  end

  def goto_run_and_save(&block)
    logger.info "goto_run_and_save"
    self.go_to
    self.instance_eval &block
    self.save
  end

  def up
    puts "up #{self.id}"
  end

  def call_with_block
    self.goto_run_and_save { up }
  end

end
