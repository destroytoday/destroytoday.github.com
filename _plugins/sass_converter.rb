module Jekyll
  require 'sass'
  require 'yui/compressor'  
  
  class SassConverter < Converter
    safe true
    priority :low

    def matches(ext)
      ext =~ /sass/i
    end

    def output_ext(ext)
      ".css"
    end

    def convert(content)
      begin
        engine = Sass::Engine.new(content, {:load_paths => ['./src/css/']})
        content = engine.render
        compressor = YUI::CssCompressor.new
        compressor.compress content
      rescue StandardError => e
        puts "!!! SASS Error: " + e.message
      end
    end
  end
end