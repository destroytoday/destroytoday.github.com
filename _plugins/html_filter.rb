module Jekyll
  
  module Filters
    require 'RMagick'
    
    def escape_liquid(input)
      input.gsub!('\{\{', '{{')
      input.gsub!('\}\}', '}}')
      input.gsub!('\%', '%')
      input.gsub!("\\\\", "\\")
      input
    end
    
    def size_images(input)
      newinput = input

      input.scan(/<img alt='([^']+)' src='([^']+)'/) {|match|
        alt = match.first
        url = match.last

        image = Magick::Image.read("#{@context.registers[:site].source}#{url}").first

        newinput = newinput.gsub("<img alt='#{alt}' src='#{url}'", "<img alt='#{alt}' src='#{url}' width='#{image.columns}' height='#{image.rows}'")
      }

      newinput
    end
    
  end

end