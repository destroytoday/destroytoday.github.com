module HTMLFilter
  def p(input)
    "<p>#{input}</p>"
  end
end

Liquid::Template.register_filter(HTMLFilter)