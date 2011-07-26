module Jekyll
  
  module Filters
    require 'RMagick'
  
    def size_images(input)
      newinput = input

      input.scan(/<img alt='([^']+)' src='([^']+)'/) {|match|
        alt = match.first
        url = match.last
        
        image = Magick::Image.read("#{@context.registers[:site].dest}#{url}").first

        newinput = newinput.gsub(/<img alt='#{alt}' src='#{url}'/, "<img alt='#{alt}' src='#{url}' width='#{image.columns}' height='#{image.rows}'")
      }

      newinput
    end
    
  end

end