module ApplicationHelper
  KB_SIZE = 1024
  MB_SIZE = 1024*KB_SIZE
  GB_SIZE = 1024*MB_SIZE

  # @param size [Bignum]
  # @return [String]
  def hsize(size)
    case size
      when 0..KB_SIZE-1 then "#{size} bytes"
      else create_tag(size)
    end
  end

  def create_tag(size)
    content_tag(:a, :href => '#', :rel => 'tooltip', "title" => "#{number_with_delimiter(size, :delimiter => ".")} bytes") do
      "#{number_to_human_size(size, :precision => 2, :separator => '.')}"
    end
  end

end
