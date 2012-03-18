class IndexedFile < ActiveRecord::Base
  belongs_to :parent, :class_name => "IndexedDirectory"

  def fullpath
    self.parent.fullpath
  end

  #Method find duplicated files
  scope :find_duplicates, select("size, count(*) as total").group("size").having("count(*) > 1").order("total")
  #Method find delete files in device
  scope :find_marked_as_deleted, lambda {|device_id| joins(:parent).where(:deleted => true, "indexed_directories.device_id" => device_id)}

  def IndexedFile.raw_sql(name,parent_id,size)
    transaction do
      connection.execute "INSERT INTO indexed_files (name,parent_id,size) values ('#{name}',#{parent_id},#{size})"
    end
  end
end
