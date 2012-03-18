# Helper para el IndexedDirectory
module DirectoryHelper
  attr_accessor :resources, :files, :directories

  def go_to
    Dir.chdir(File.join(self.device.name, self.fullpath))
    load_resources
  end

  def load_resources
    @resources = Dir.glob("*")
    @directories = @resources.select { |x| FileTest.directory?(x) }
    @files = @resources - @directories
    @resources
  end

  # Method for find new elements
  def find_new_directories
    @directories.select { |directory| !self.child_indexeddirectory?(directory) }
  end

  def child_indexeddirectory?(directory)
    self.indexed_directories.any? { |indexed_directory| indexed_directory.name == directory }
  end

  def find_new_files
    @files.select { |file| !self.child_indexedfile?(file) }
  end

  def child_indexedfile?(file)
    self.indexed_files.any? { |indexed_file| indexed_file.name == file }
  end

  def find_old_indexeddirectories
    self.indexed_directories.select {|indexed_directory| !self.directories.index(indexed_directory.name)}
  end

  def find_old_indexedfiles
    self.indexed_files.select {|indexed_file| !self.files.index(indexed_file.name)}
  end


end