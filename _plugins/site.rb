module Jekyll
  class Site
    require 'growl'
    
    alias :super_process :process
    
    def process
      time = Time.now
      super_process()
      
      duration = (Time.now - time).to_i
      
      puts "Compile time #{duration} seconds"
	    Growl.notify("Auto-build complete (#{duration} sec)", :title => 'Jekyll')
    end
  end
end