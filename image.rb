require 'rmagick'
require 'fileutils'

class String
  def titleize
    split(/(\W)/).map(&:capitalize).join
  end
end

def write_post
  date = Time.new.strftime("%Y-%m-%d")
  path = "src/blog/_posts/#{date}-#{@id}.maruku"
  title = @id.gsub(/\-/i, ' ').titleize
  colors = extract @img
  
  content = <<EOF
---
layout: blog-post
title: #{title}
shortname: #{title}
category: blog
tags: []
thumbnail: 
  image: #{@thumb_filename}
  colors: #{colors}
---
![#{title}](/assets/blog/#{@id}/#{@filename})  
EOF
  
  File.open(path, 'w') {|file|
    file.write content
  }
end

def extract img
  img_lowquality = img.quantize(256)
  
  colors_hash = {}
  
  def to8bit dec
    ((dec / 65535.0) * 255).round.to_s
  end
  
  img_lowquality.color_histogram.each_pair do |pixel, frequency|
    color_string = "#{to8bit(pixel.red)},#{to8bit(pixel.green)},#{to8bit(pixel.blue)},#{pixel.opacity}"

    if colors_hash[color_string].nil?
      colors_hash[color_string] = frequency.to_i
    else
      colors_hash[color_string] += frequency.to_i
    end
  end
  
  sorted_colors = []
  
  colors_hash.each { |key, value|
    sorted_colors.push({:key => key, :value => value})
  }
  
  sorted_colors.sort! { |a, b|
    b[:value] <=> a[:value]
  }
  
  unique_colors = []
  
  sorted_colors.each { |c|
    c_rgba = c[:key].split(',')
    valid = true
    
    unique_colors.each { |uc|
      uc_rgba = uc[:key].split(',')
      c_diff = 0
      
      3.times { |i|
        c_diff += (c_rgba[i].to_i - uc_rgba[i].to_i).abs
      }
      
      if c_diff / 4 < 35
        valid = false
        break
      end
    }
    
    unique_colors.push(c) if valid
    
    break if unique_colors.length >= 4
  }
  
  color_data = ''
  
  unique_colors.each { |uc|
    hex = ''
    rgba = uc[:key].split(',')
    
    3.times { |i|
      hex << "%02s" % (rgba[i].to_i.to_s(16))
    }
    
    hex.gsub!(/ /, '0')
    hex = "'#{hex.upcase}'"
    
    if color_data.empty?
      color_data = hex
    else
      color_data << ', ' << hex
    end
  }
  
  color_data = "[#{color_data}]"
  color_data
end

def resize_to_blog img
  newimg = img.resize_to_fit(666)
  newimg = newimg.unsharp_mask(1.1, 1.0, 0.4)
  newimg.write("#{@img_dir}/#{@filename}")
end

def resize_to_thumb img
  thumb_filename = img.filename.gsub(@exp, '\\1-thumb.\\2')
  newimg = img.resize_to_fill(200, 200)
  newimg = newimg.unsharp_mask(1.1, 1.0, 0.4)
  newimg.write("#{@img_dir}/#{thumb_filename}")
end

def copy_hires img
  filename = img.filename.gsub(@exp, '_\\1-hires.\\2')
  FileUtils.cp img.filename, @img_dir + '/' + filename
end

@img = Magick::Image.read(ARGV[0]).first

@exp = /\S+\/(\S+)\.(\w+)$/i
@id = @img.filename.gsub(@exp, '\\1')
@img_dir = "src/assets/blog/#{@id}"
@filename = @img.filename.gsub(@exp, '\\1.\\2')

FileUtils.mkdir @img_dir unless File.exists? @img_dir

if ARGV.include? '--fit'
  resize_to_blog @img
elsif ARGV.include? '--thumb'
  resize_to_thumb @img
else
  copy_hires @img
  resize_to_blog @img
  resize_to_thumb @img
  write_post
end