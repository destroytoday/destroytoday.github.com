module Jekyll
  
  module Filters
    #require 'RMagick'
  
    def size_images(input)
      newinput = input
=begin      
      input.scan(/<img src='([^']+)'/) {|url|
        image = Magick::Image.read("#{@context.registers[:site].dest}/#{url}").first
      
        newinput = newinput.gsub(/<img src='#{url}'/, "<img src='#{url}' width='#{image.columns}' height='#{image.rows}'")
      }
=end      
      newinput
    end
    
  end

end