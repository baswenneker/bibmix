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
		    		when 'fril'
		    			result = FrilSimilarityDecorator.new(result)
		    		when 'year'
		    			result = YearSimilarityDecorator.new(result)
		    	end
		    end
		    
		    result
		  end 
		end
	end
end