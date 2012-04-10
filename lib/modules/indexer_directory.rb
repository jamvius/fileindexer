module IndexerDirectory
  def index(recursive=false, overwrite=false, recursive_level = 0)
    return if !self.indexable

    self.go_to

    self.analyze_content
    if (!self.indexed? and !self.partial_indexed?) or overwrite
      self.index_content(overwrite)
    end

    if self.recursive and (recursive or recursive_level > 0)
      self.add_new_directories
      self.indexed_directories.each { |directory|
        directory.index(recursive, overwrite, recursive_level-1)
      }
    end

    self.analyze_status
    self.index_status
    self.save
  end

  def index_content(overwrite = false)
    if (self.indexed? or self.partial_indexed?) and overwrite
      self.mark_old_resources
      self.update_files
      self.add_new_directories
      self.add_new_files
    else
      self.add_all_directories
      self.add_all_files
    end
  end

  def mark_old_resources

    self.find_old_indexeddirectories.each { |indexed_directory|
      indexed_directory.deleted = true
      indexed_directory.save
    }

    self.find_old_indexedfiles.each { |indexed_file|
      indexed_file.deleted = true
      indexed_file.save
    }

  end

  def update_files
    self.indexed_files.each { |indexed_file|
      if File.exist?(indexed_file.name)
        indexed_file.size = File.size(indexed_file.name)
        indexed_file.save
      end
    }
  end

  def index_status

    self.indexed = (self.indexed_files.size == self.files.size and self.indexed_directories.size == self.directories.size)

    self.recursive_indexed = (self.directories.size == self.indexed_directories.size and
        self.indexed_directories.all? { |indexed_directory| indexed_directory.recursive_indexed })

    self.size = self.indexed_files.inject(0) { |total, indexed_file|
      total + indexed_file.size
    }

    self.recursive_size = self.indexed_directories.inject(0) { |total, indexed_directory|
      total + indexed_directory.size + indexed_directory.recursive_size
    }

  end

  def add_all_directories

    if self.directories.size > 0
      t = Time.now.utc
      values = self.directories.collect { |directory| "('#{directory}',#{self.id},#{self.device.id},'#{t}','#{t}')" }
      massive_query = "INSERT INTO indexed_directories (name, parent_id, device_id, created_at, updated_at) VALUES #{values.join(',')}"
      self.connection.execute massive_query
      self.indexed_directories.reload
    end

  end

  def add_new_directories

    list_directories = find_new_directories
    if list_directories.size > 0
      t = Time.now.utc
      values = list_directories.collect { |directory| "('#{directory}',#{self.id},#{self.device.id},'#{t}','#{t}')" }
      massive_query = "INSERT INTO indexed_directories (name, parent_id, device_id, created_at, updated_at) VALUES #{values.join(',')}"
      self.connection.execute massive_query
      self.indexed_directories.reload
    end


  end


  def add_all_files

    if self.files.size > 0
      t = Time.now.utc
      values = self.files.collect { |file| "(\"#{file}\",#{File.size(file)},#{self.id},\"#{t}\",\"#{t}\")" }
      massive_query = "INSERT INTO indexed_files (name, size, parent_id, created_at, updated_at) VALUES #{values.join(',')}"

      self.connection.execute massive_query
      self.indexed_files.reload
    end
  end

  def add_new_files

    list_files = find_new_files
    if list_files.size > 0
      t = Time.now.utc
      values = list_files.collect { |file| "(\"#{file}\",#{File.size(file)},#{self.id},\"#{t}\",\"#{t}\")" }
      massive_query = "INSERT INTO indexed_files (name, size, parent_id, created_at, updated_at) VALUES #{values.join(',')}"

      self.connection.execute massive_query
      self.indexed_files.reload
    end


  end


end