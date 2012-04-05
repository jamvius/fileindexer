module StatusDirectory

  def update_status
    self.go_to

    self.numfiles = self.files.size
    self.numdirectories = self.directories.size

    self.analyzed = true
    self.indexed = (self.indexed_files.size == self.files.size and self.indexed_directories.size == self.directories.size)

    self.size = self.files.inject(0) { |total, file|
      total + File.size(file)
    }

    self.save
  end

  def update_children_status
    self.go_to

    self.recursive_analyzed = (self.directories.size == self.indexed_directories.size and
        self.indexed_directories.all? {|indexed_directory| indexed_directory.recursive_analyzed })

    self.recursive_indexed = (self.directories.size == self.indexed_directories.size and
        self.indexed_directories.all? { |indexed_directory| indexed_directory.recursive_indexed })

    self.recursive_numfiles = self.indexed_directories.inject(0) { |total, indexed_directory|
      total + indexed_directory.numfiles + indexed_directory.recursive_numfiles
    }
    self.recursive_numdirectories = self.indexed_directories.inject(0) { |total, indexed_directory|
      total + indexed_directory.numdirectories + indexed_directory.recursive_numdirectories
    }

    self.recursive_size = self.indexed_directories.inject(0) { |total, indexed_directory|
      total + indexed_directory.size + indexed_directory.recursive_size
    }

    self.save
  end

end