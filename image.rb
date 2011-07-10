#!/usr/bin/env ruby

require 'RubyGems'
require 'RMagick'

image = Magick::Image.read(ARGV[0]).first

image.resize!(200, 200)
newimg = image.unsharp_mask(1.1, 1.0, 0.4)
newimg.write("output.jpg")
