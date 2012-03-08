class StatusTask < ActiveRecord::Base

  def StatusTask.method_missing(m, *args, &block)
    begin
      super(m, *args, &block)
    rescue NoMethodError
      puts "There's no method called #{m} here -- Search status BD."
      StatusTask.find_by_name(m.downcase)
    end
  end

end
