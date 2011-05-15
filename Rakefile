desc "Launch preview environment"

task :default => [:compress, :jekyll, :compass, :tidy]

#task :haml do
#	system("for i in ./src/_layouts/*.haml; do [ -e $i ] && n=${i%.haml} && haml $i ./src/_layouts/${n##*/}.html; done") # & compass watch
#	system("for i in ./src/_includes/*.haml; do [ -e $i ] && n=${i%.haml} && haml $i ./src/_includes/${n##*/}.html; done")
#end

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