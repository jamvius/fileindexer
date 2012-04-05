module AnalyzerDirectory
  def analyze(recursive=false, overwrite=false, recursive_level = 0)
    return if !self.indexable

    self.go_to

    self.analyze_content

    if self.recursive and (recursive or recursive_level > 0)
      self.add_new_directories
      self.indexed_directories.each { |directory|
        directory.analyze(recursive, overwrite, recursive_level-1)
      }
    end

    self.analyze_status
    self.save
  end

  def analyze_content
    self.numfiles = self.files.size
    self.numdirectories = self.directories.size
  end

  def analyze_status
    self.analyzed = (self.numfiles == self.files.size and self.numdirectories == self.directories.size)
    self.recursive_analyzed = (self.directories.size == self.indexed_directories.size and
        self.indexed_directories.all? {|indexed_directory| indexed_directory.recursive_analyzed })

    self.recursive_numfiles = self.indexed_directories.inject(0) { |total, indexed_directory|
      total + indexed_directory.numfiles + indexed_directory.recursive_numfiles
    }
    self.recursive_numdirectories = self.indexed_directories.inject(0) { |total, indexed_directory|
      total + indexed_directory.numdirectories + indexed_directory.recursive_numdirectories
    }

  end


end