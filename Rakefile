require 'rubygems'
require 'growl'
require 'coffee-script'
require 'fileutils'
require 'tidy_ffi'

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

task :default => [:jekyll_debug, :success]

task :release => [:jekyll_release, :index, :success]

#--------------------------------------------------------------------------
#
#  Tasks
#
#--------------------------------------------------------------------------

desc "Runs Jekyll (debug)"
task :jekyll_debug do
	output = `jekyll --no-auto`; result = $?.success?
	
	puts output
	
	fail unless result
end

desc "Runs Jekyll (release)"
task :jekyll_release do
	output = `jekyll --lsi`; result = $?.success?
	
	puts output
	
	fail unless result
end

desc "Runs Jekyll (server)"
task :server do
  system("jekyll --auto --server 1337");
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
      file.write TidyFFI::Tidy.new(content, :numeric_entities => 1, :output_xhtml => 1, :merge_divs => 0, :clean => 1, :indent => 1, :wrap => 0, :drop_empty_paras => 0).clean
    }
  end
end

desc "Deploys to Beanstalk"
task :deploy do
	system("git push beanstalk master")
end

task :success do
	Growl.notify 'Build complete', :title => 'destroytoday.com'
end