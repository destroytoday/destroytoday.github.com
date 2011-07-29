module Jekyll
  require 'sass'
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
        engine = Sass::Engine.new(content, {:load_paths => ['./src/css/', '/Users/jhallman/dev/ruby/compass/frameworks/compass/stylesheets/']})
        engine.render
      rescue StandardError => e
        puts "!!! SASS Error: " + e.message
      end
    end
  end
end