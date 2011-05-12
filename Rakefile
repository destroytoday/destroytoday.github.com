desc "Launch preview environment"

task :default => [:jekyll, :compass, :tidy]

#task :haml do
#	system("for i in ./src/_layouts/*.haml; do [ -e $i ] && n=${i%.haml} && haml $i ./src/_layouts/${n##*/}.html; done") # & compass watch
#	system("for i in ./src/_includes/*.haml; do [ -e $i ] && n=${i%.haml} && haml $i ./src/_includes/${n##*/}.html; done")
#end

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
	system("for i in ./site/*.html; do [ -e $i ] && tidy -im ${i}; done")
end