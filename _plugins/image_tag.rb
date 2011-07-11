module Image
  class ImageTag < Liquid::Tag
    require 'RMagick'

    SYNTAX = /(?:'|")([^ ]+)(?:'|")\s?(?:(?:'|")(.+)(?:'|"))*/

    def initialize(tag_name, markup, tokens)
      super
      if markup =~ SYNTAX
        @url = $1
        @alt = $2 if defined? $2
      else
        raise SyntaxError.new("Syntax Error in 'image' - Valid syntax: image <url> [alt]")
      end
    end

    def render(context)
      image = Magick::Image.read("#{context.registers[:site].dest}/#{@url}").first
      @alt = " alt=\"#{@alt}\"" unless @alt.nil?
    
      "<img src=\"#{@url}\" width=\"#{image.columns}\" height=\"#{image.rows}\"#{@alt} />"
    end
  end
end

Liquid::Template.register_tag('image', Image::ImageTag)