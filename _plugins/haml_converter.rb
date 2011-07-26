module Jekyll
  require 'haml'
  class HamlConverter < Converter
    safe true
    priority :low

    def matches(ext)
      ext =~ /haml/i
    end

    def output_ext(ext)
      ".html"
    end

    def convert(content)
      begin
        engine = Haml::Engine.new(content, {:attr_wrapper => '"', :escape_html => true})
        engine.render
      rescue StandardError => e
          puts "!!! HAML Error: " + e.inspect
      end
    end
  end
end