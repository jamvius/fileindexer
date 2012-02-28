class IndexedFile < ActiveRecord::Base
  belongs_to :parent, :class_name => "IndexedDirectory"

  def fullpath
    self.parent.fullpath
  end
end
