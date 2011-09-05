module Jekyll
  
  module Filters
    require 'RMagick'
    
    def escape_liquid(input)
      newinput = input.gsub('\{\{', '{{')
      newinput.gsub!('\}\}', '}}')
      newinput.gsub!('\%', '%')
      newinput.gsub!("\\\\", "\\")
      newinput
    end
    
    def escape_doublequotes(input)
      newinput = input.gsub("\"", "\\\"")
      newinput
    end
    
    def remarry_widows(input)
      newinput = input.gsub(/ ([^ ]+)$/, "&nbsp;\\1")
      newinput
    end
    
    def size_images(input)
      newinput = input

      input.scan(/<img(.*) src=(?:'|")([^'"]+)(?:'|")/) {|match|
        params = match.first
        url = match.last

        image = Magick::Image.read("#{@context.registers[:site].source}#{url}").first

        newinput = newinput.gsub(/<img#{params} src=('|")#{url}('|")/, "<img#{params} src=\"#{url}\" width=\"#{image.columns}\" height=\"#{image.rows}\"")
      }

      newinput
    end
    
  end

end