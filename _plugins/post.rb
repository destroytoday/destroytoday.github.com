module Jekyll
  class Post
  
    alias orig_render render
    def render(layouts, site_payload)
        res = orig_render(layouts, site_payload)
        self.output = fix_liquid_escapes(self.output)
        res
    end

    def fix_liquid_escapes(s)
        s.gsub!('\{\{', '{{')
        s.gsub!('\}\}', '}}')
        s.gsub!('\%', '%')
        s.gsub!("\\\\", "\\")
        s
    end
  end
end