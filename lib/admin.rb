#!/usr/bin/env ruby

require 'yaml'
require 'time'
require 'rmagick'
require 'fileutils'

module Jekyll
  class Admin
    
    def initialize
      load_config
    end
    
    def load_config
      config = YAML.load_file('_config.yml')
      
      @source = config['source']
      @destination = config['destination']
    end
    
    def post title, image_path=nil, time=Time.now.to_s
      post = Post.new(title, image_path, Time.parse(time))
      
      post.write "#{@source}/blog/_posts"
      
      if image_path
        post.copy_image "#{@source}/assets/blog"
        post.create_thumb "#{@source}/assets/blog"
      end

      puts "Created new post: #{post.filename}"
    end
    
    def image post, title, image_path
      image = Image.new(post, title, image_path)
      
      image.copy "#{@source}/assets/blog"
      image.create_fitted "#{@source}/assets/blog"
    end
    
    def rm_post slug
      post = Dir.glob("#{@source}/blog/_posts/*-*-*-#{slug}.maruku")
      assets = "#{@source}/assets/blog/#{slug}"
      
      FileUtils.rm_rf(post)
      FileUtils.rm_rf(assets)
      
      puts "Removed #{post}"
      puts "Removed #{assets}"
    end
  end
  
  class Post
    def initialize title, image_path, time
      @title = title
      @image = image_path ? Magick::ImageList.new(image_path) : nil
      @time = time
    end
    
    def slug
      @title.gsub(/[^a-z0-9\-_ ]+/i, '').gsub(/[ \-]+/, '-').downcase
    end
    
    def filename
      "#{shorttime}-#{slug}.maruku"
    end
    
    def shorttime
      @time.strftime('%Y-%m-%d')
    end
    
    def longtime
      @time.strftime('%Y-%m-%d %H:%M:%S')
    end
    
    def img_regex
      /\S+\/(\S+)\.(\w+)$/i
    end
    
    def img_ext
      @image ? @image.filename.gsub(img_regex, '\\2') : ''
    end
    
    def thumb_hires_filename
      @image ? "_#{slug}-thumb-hires.#{img_ext}" : ''
    end
    
    def thumb_filename
      "#{slug}-thumb.#{img_ext}"
    end
    
    def write dir
      path = "#{dir}/#{filename}"
      
      File.open(path, 'w') do |file|
        file.puts "---"
        file.puts "layout: blog-post"
        file.puts "title: #{@title}"
        file.puts "shortname: #{@title}"
        file.puts "date: #{longtime}"
        file.puts "category: blog"
        file.puts "tags: []"
        file.puts "thumbnail: "
        file.puts "  image: #{thumb_filename}"
        file.puts "  colors: ['000000', 'FFFFFF']"
        file.puts "---"
      end
    end
    
    def copy_image dir
      dir = "#{dir}/#{slug}"
      
      FileUtils.mkdir(dir) unless File.exists? dir
      
      FileUtils.cp(@image.filename, "#{dir}/#{thumb_hires_filename}")
    end
    
    def create_thumb dir
      dir = "#{dir}/#{slug}"
      path = "#{dir}/#{thumb_filename}"
      
      FileUtils.mkdir(dir) unless File.exists? dir
      
      if @image.columns > 200 || @image.rows > 200
        resized_thumb = @image.resize_to_fill(200, 200)
        sharpened_thumb = resized_thumb.unsharp_mask(1.1, 1.0, 0.4)
      
        sharpened_thumb.write(path)
      
        resized_thumb.destroy!
        sharpened_thumb.destroy!
      else
        @image.write(path)
      end
    end
  end
  
  class Image
    def initialize post, title, image_path
      @post = post
      @title = title
      @image = Magick::ImageList.new(image_path)
    end
    
    def slug
      @post + (!@title.empty? ? "-" + @title.gsub(' ', '-').gsub(/[^a-z0-9\-_]+/i, '').downcase : '')
    end
    
    def regex
      /\S+\/(\S+)\.(\w+)$/i
    end
    
    def filename
      "#{slug}.#{ext}"
    end
    
    def ext
      @image.filename.gsub(regex, '\\2')
    end
    
    def hires_filename
      "_#{slug}-hires.#{ext}"
    end
    
    def copy dir
      dir = "#{dir}/#{@post}"
      
      FileUtils.mkdir(dir) unless File.exists? dir
      
      FileUtils.cp(@image.filename, "#{dir}/#{hires_filename}")
    end
    
    def create_fitted dir
      dir = "#{dir}/#{@post}"
      path = "#{dir}/#{filename}"
      
      FileUtils.mkdir(dir) unless File.exists? dir
      
      if @image.columns > 666
        resized_image = @image.resize_to_fit(666)
        sharpened_image = resized_image.unsharp_mask(1.1, 1.0, 0.4)
      
        sharpened_image.write(path)
      
        resized_image.destroy!
        sharpened_image.destroy!
      else
        @image.write(path)
      end
    end
  end
end