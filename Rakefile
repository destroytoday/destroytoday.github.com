require 'growl'

task :default => [:cd, :compress, :jekyll, :compass, :tidy, :growl]

task :cd do
	system("cd ~/dev/web/destroytoday.com")
	system("pwd")
end

task :compress do
	system("java -jar build/yuicompressor-2.4.6.jar src/js/_jquery.destroytoday.js -o src/js/jquery.destroytoday.min.js
")
end

task :compass do
	system("compass compile")
end

task :jekyll do
	system("jekyll")
end

task :preview do
	system("jekyll --auto --server")
end

task :tidy do
	system("for i in ./site/*.html; do [ -e $i ] && tidy -imqcb ${i}; done")
end

task :deploy do
	system("git push beanstalk master")
end

task :growl do
	Growl.notify 'Build complete', :title => 'destroytoday.com'
end