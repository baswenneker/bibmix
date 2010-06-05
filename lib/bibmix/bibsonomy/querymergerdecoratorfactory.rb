require 'bibmix/bibsonomy'
require 'singleton'

module Bibmix
	module Bibsonomy
		
		class QueryMergerDecoratorFactory
			include Singleton
						
			def method_missing(method, *args)  
		    decorators = method.to_s.split('_').reverse!
		    
		    result = args[0]
		    decorators.each do |decorator_name|
		    	
		    	case decorator_name
		    		when 'page'
		    			result = PagesSimilarityDecorator.new(result)
		    		when 'title'
		    			result = TitleSimilarityDecorator.new(result)
		    		when 'year'
		    			result = YearSimilarityDecorator.new(result)
		    	end
		    end
		    
		    result
		  end 
		end
	end
		

#		module QueryMergerFactory
#			
#			def self.method_missing(method, *args)  
#		    decorators = method.split('_').reverse!
#		    puts decorators.to_yaml
#		    result = args[0]
#		    decorators.each do |decorator_name|
#		    	case decorator_name
#		    		when 'page'
#		    			result = PagesSimilarityDecorator.new(result)
#		    		when 'title'
#		    			result = TitleSimilarityDecorator.new(result)
#		    		when 'year'
#		    			result = YearSimilarityDecorator.new(result)
#		    	end
#		    end
#		    
#		    result
#		  end 
#			
#			def self.pages(querymerger)
#				PagesSimilarityDecorator.new(
#					querymerger
#				)
#			end
#			
#			def self.title(querymerger)
#				TitleSimilarityDecorator.new(
#					querymerger
#				)
#			end
#			
#			def self.year(querymerger)
#				YearSimilarityDecorator.new(
#					querymerger
#				)
#			end
#			
#			def self.pages_year_title(querymerger)
#				self.pages(
#					self.year(
#						querymerger
#					)
#				)
#			end
#			
#			def self.year_title(querymerger)
#				self.year_merger(
#					self.title_merger(
#						querymerger
#					)
#				)
#			end
#		end
#	end
end