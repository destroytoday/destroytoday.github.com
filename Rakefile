require 'rubygems'
require 'growl'
require "serialport"

def arduinoExists?
  return File.exists? "/dev/tty.usbmodem411"
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
  port_str = "/dev/tty.usbmodem411"
  baud_rate = 9600
  data_bits = 8
  stop_bits = 1
  parity = SerialPort::NONE

  @sp = SerialPort.new(port_str, baud_rate, data_bits, stop_bits, parity)
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

task :default => [:setup, :compress, :jekyll, :compass, :success]

task :setup do
  setup if arduinoExists?
  
	output = `cd ~/dev/web/destroytoday.com`; result = $?.success?
  system('pwd')
  
  puts output
  
	fail unless result
end

task :compress do
	system("java -jar build/yuicompressor-2.4.6.jar src/js/_jquery.destroytoday.js -o src/js/jquery.destroytoday.min.js
")
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

task :server do
  system("jekyll --server");
end

task :preview do
	system("jekyll --auto --server")
end

task :tidy do
	output = `for i in ./site/*.html; do [ -e $i ] && tidy -imqcb ${i}; done`; result = $?.success?
	  
	puts output
	  
	fail unless result
end

task :deploy do
	system("git push beanstalk master")
end

task :success do
	Growl.notify 'Build complete', :title => 'destroytoday.com'
	success
end