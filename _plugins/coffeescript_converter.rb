module Jekyll
  require 'coffee-script'
  require 'yui/compressor'
  
  class CoffeescriptConverter < Converter
    safe true
    priority :low

    def matches(ext)
      ext =~ /coffee/i
    end

    def output_ext(ext)
      ".min.js"
    end

    def convert(content)
      begin
        compressor = YUI::JavaScriptCompressor.new
        compressor.compress CoffeeScript.compile content
      rescue StandardError => e
          puts "!!! Coffeescript Error: " + e.inspect
      end
    end
  end
end