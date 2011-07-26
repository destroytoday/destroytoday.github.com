require 'rubygems'
require 'growl'
#require "serialport"
require 'coffee-script'

def arduinoExists?
  return File.exists?("/dev/tty.RN42-A82F-SPP")
end

def light color, delay=1
  if arduinoExists?
    @sp.putc(color)
    puts color
    sleep(delay)
  end
end

def flash color
  4.times do
    light color, 0.5
    light 'q', 0.5
  end if arduinoExists?
end

def setup
  port_str = "/dev/tty.RN42-A82F-SPP"
  baud_rate = 115200
  data_bits = 8
  stop_bits = 1
  #parity = SerialPort::NONE

  #@sp = SerialPort.new(port_str, baud_rate, data_bits, stop_bits, parity)
  light(' ')
  sleep(1)
  light('c')
end

def closeSerial
  @sp.close if arduinoExists?
end

def success
  flash 'g'
  closeSerial
end

def fail
  Growl.notify 'Build failed', :title => 'destroytoday.com'
  
  flash 'y' #change to red when you get the red LED
  closeSerial
  exit
end

task :default => [:javascript, :jekyll, :compass, :index, :success]

task :release => [:javascript, :jekyll_release, :compass, :index, :success]

task :arduino => [:setup, :default]

task :setup do
  setup if arduinoExists?
  
	#output = `cd ~/dev/web/destroytoday.com`; result = $?.success?
  system('pwd')
  
  #puts output
  
	#fail unless result
end

task :javascript do
  Dir.glob('src/js/*.coffee') do |path|
    to_path = path.gsub('.coffee', '.js')
    to_min_path = to_path.gsub('.js', '.min.js').gsub(/\/_/, '/')

    File.open(to_path, 'w') {|f| 
      f.write(CoffeeScript.compile File.read(path))
    }
    
    system "java -jar build/yuicompressor-2.4.6.jar #{to_path} -o #{to_min_path}"
  end
  
  `java -jar build/yuicompressor-2.4.6.jar src/js/_jquery.destroytoday.js -o src/js/jquery.destroytoday.min.js`
end

task :compass do
	output = `compass compile`; result = $?.success?
	
	puts output
	
	fail unless result
end

task :jekyll do
	output = `jekyll`; result = $?.success?
	
	puts output
	
	fail unless result
end

task :jekyll_release do
	output = `jekyll --lsi`; result = $?.success?
	
	puts output
	
	fail unless result
end

task :server do
  system("jekyll --server 1337");
end

task :preview do
	system("jekyll --auto --server")
end

task :tidy do
	output = `for i in ./site/*.html; do [ -e $i ] && tidy -imqcb ${i}; done`; result = $?.success?
	  
	puts output
	  
	fail unless result
end

task :index do
  index = "["
  n = 0
  
  Dir.glob('site/blog/*/index.html') do |path|
    File.open(path) {|file|
      content = file.read
      
      content = content.scan(/<p>(.+)<\/p>/i).to_s
      content = content.gsub /(<[^>]+>|&#[^;]+;|\n|\r|")/i, ''
      
      if n > 0
        index = index + ","
      end
        
      index = index + "\"path\":\"#{file.path}\","
      index = index + "\"content\":\"#{content}\"},"
      #index = index + "\"thumbnail\":{"
      #index = index + "\"image\":\"#{image}\"},"
      #index = index + "\"colors\":\"#{image}\"},"
      #index = index + "}"
      
      n = n + 1
    }
  end
  
  index = index + "]"
  
  File.open('site/js/blog_index.json', 'w') {|f| f.write(index) }
end

task :deploy do
	system("git push beanstalk master")
end

task :success do
	Growl.notify 'Build complete', :title => 'destroytoday.com'
	success
end