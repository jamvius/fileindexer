module ApplicationHelper
  KB_SIZE = 1024
  MB_SIZE = 1024*KB_SIZE
  GB_SIZE = 1024*MB_SIZE

  # @param size [Bignum]
  # @return [String]
  def hsize(size)
    case size
      when 0..KB_SIZE-1 then "#{size} bytes"
      when KB_SIZE..MB_SIZE-1 then "#{size.fdiv(KB_SIZE).round(2)} Kb (#{size} bytes)"
      when MB_SIZE..GB_SIZE-1 then "#{size.fdiv(MB_SIZE).round(2)} Mb (#{size} bytes)"
      else "#{size.fdiv(GB_SIZE).round(2)} Gb (#{size} bytes)"
    end
  end

end
