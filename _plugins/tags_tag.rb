module Jekyll

  class Tags < Liquid::Block
    def initialize(tag_name, file, tokens)
      super
    end

    def render(context)
      input = super.to_s
      output = ''
      
      context.registers[:site].tags.keys.each do |tag|
        output << input.gsub('%tag%', tag)
      end
      
      output
    end
  end

end

Liquid::Template.register_tag('tags', Jekyll::Tags)
