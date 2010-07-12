# This file is executed when the plugin is installed through script/plugin install bibmix
if not Gem.available?('faster(_)?csv')
	puts 'Please install fastercsv: sudo gem install fastercsv'
end
