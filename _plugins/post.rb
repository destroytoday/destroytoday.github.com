module Jekyll
  class Post
    alias :super_to_liquid :to_liquid
    
    def to_liquid
      super_to_liquid.deep_merge({"slug" => slug})
    end
  end
end