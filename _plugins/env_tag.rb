module Jekyll

  class EnvLocal < Liquid::Block
    def initialize(tag_name, markup, tokens)
      super
    end

    def render(context)
      if context.registers[:site].config['url'] == context.registers[:site].config['env']['local']
        super
      else
        ''
      end
    end
  end
  
  class EnvStaging < Liquid::Block
    def initialize(tag_name, markup, tokens)
      super
    end

    def render(context)
      if context.registers[:site].config['url'] == context.registers[:site].config['env']['staging']
        super
      else
        ''
      end
    end
  end
  
  class EnvProduction < Liquid::Block
    def initialize(tag_name, markup, tokens)
      super
    end

    def render(context)
      if context.registers[:site].config['url'] == context.registers[:site].config['env']['production']
        super
      else
        ''
      end
    end
  end

end

Liquid::Template.register_tag('local', Jekyll::EnvLocal)
Liquid::Template.register_tag('staging', Jekyll::EnvStaging)
Liquid::Template.register_tag('production', Jekyll::EnvProduction)
