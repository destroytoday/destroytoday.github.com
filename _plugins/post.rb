module Jekyll
  class Post
    alias :super_to_liquid :to_liquid
    
    def to_liquid
      super_to_liquid.deep_merge({
        "slug" => self.slug,
        "disqus_id" => "#{self.dir}/#{self.data["disqus_id"] || self.slug}" })
    end
  end
end