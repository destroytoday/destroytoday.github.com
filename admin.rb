#!/usr/bin/env ruby

require 'yaml'

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
    
    def newpost title, image, time=Time.now.strftime('%Y-%m-%d')
      slug = title.gsub ' ', '-' # convert spaces to dashes
      slug.gsub! /[^a-z0-9\-_]+/, '' # remove unsafe chars
      
      path = "#{@source}/blog/_posts/#{time}-#{slug}.maruku"
      thumb = "#{slug}-thumb.png"

      File.open(path, 'w') do |file|
        file.puts "---"
        file.puts "layout: blog_post"
        file.puts "title: #{title}"
        file.puts "shortname: #{title}"
        file.puts "date: #{Time.now.strftime('%Y-%m-%d %H:%M')}"
        file.puts "category: blog"
        file.puts "tags: []"
        file.puts "thumbnail: "
        file.puts "  image: #{thumb}"
        file.puts "  colors: ['000000', 'FFFFFF']"
        file.puts "---"
        file.puts content
      end

      puts "Created new post: #{path} - \"#{content}\""
    end
  end
end

method_name = ARGV[0]

action = "admin.#{method_name}"

if ARGV.length > 1
  action << " \"" + ARGV[1..ARGV.length].join('", "') + "\""
end

admin = Jekyll::Admin.new
eval action