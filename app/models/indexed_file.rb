class IndexedFile < ActiveRecord::Base
  belongs_to :parent, :class_name => "IndexedDirectory"

  def fullpath
    self.parent.fullpath
  end

  #Method find duplicated files
  scope :find_duplicates, select("md5, count(*) as total").group("md5").having("count(*) > 1").order("total")
  #Method find delete files in device
  scope :find_marked_as_deleted, lambda {|device_id| joins(:parent).where(:deleted => true, "indexed_directories.device_id" => device_id)}
end
