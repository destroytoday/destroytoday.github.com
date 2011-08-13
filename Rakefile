require 'rubygems'
require 'growl'
require 'coffee-script'
require 'fileutils'
require 'tidy_ffi'

#--------------------------------------------------------------------------
#
#  Properties
#
#--------------------------------------------------------------------------

@time = Time.now

#--------------------------------------------------------------------------
#
#  Helper Methods
#
#--------------------------------------------------------------------------

def fail
  Growl.notify 'Build failed', :title => 'destroytoday.com'
end

#--------------------------------------------------------------------------
#
#  Task Chains
#
#--------------------------------------------------------------------------

task :default => :local

task :local => [:jekyll_local, :success]

task :staging => [:jekyll_staging, :success]

task :production => [:jekyll_production, :success]

#--------------------------------------------------------------------------
#
#  Tasks
#
#--------------------------------------------------------------------------

desc "Runs Jekyll (local)"
task :jekyll_local do
	output = `jekyll --url http://localhost:1337`; result = $?.success?
	
	puts output
	
	fail unless result
end

desc "Runs Jekyll (staging)"
task :jekyll_staging do
	output = `jekyll --url http://staging.destroytoday.com`; result = $?.success?
	
	puts output
	
	fail unless result
end

desc "Runs Jekyll (production)"
task :jekyll_production do
	output = `sudo jekyll --url http://destroytoday.com --lsi`; result = $?.success?
	
	puts output
	
	fail unless result
end

desc "Runs Jekyll (server)"
task :server do
  system("jekyll --url http://localhost:1337 --auto --server 1337");
end

desc "Indexes blog posts"
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

desc "Tidies HTML files"
task :tidy do
  Dir.glob('site/**/*.html') do |path|
    content = File.open(path).read
    
    File.open(path, 'w') {|file|
      file.write TidyFFI::Tidy.new(content, :numeric_entities => 1, :output_html => 1, :merge_divs => 0, :join_styles => 0, :clean => 1, :indent => 1, :wrap => 0, :drop_empty_paras => 0, :literal_attributes => 1).clean
    }
  end
end

desc "Deploys to Beanstalk"
task :deploy do
	system("git push beanstalk master")
end

task :success do
  duration = (Time.now - @time).to_i
  
  puts "Compile time #{duration} seconds"
	Growl.notify "Build complete (#{duration} sec)", :title => 'destroytoday.com'
end