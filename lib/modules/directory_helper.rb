# Helper para el IndexedDirectory
module DirectoryHelper
  attr_accessor :resources, :files, :directories

  def go_to
    Dir.chdir(File.join(self.device.name,self.fullpath))
    load_resources
  end

  def load_resources
    @resources = Dir.glob("*")
    @directories = @resources.select { |x| FileTest.directory?(x) }
    @files = @resources - @directories
    @resources
  end
end