require 'bibmix'
require 'singleton'

module Bibmix
	class FilterDecoratorFactory
		include Singleton
					
		def method_missing(method, *args)  
	    decorators = method.to_s.split('_').reverse!
	    
	    result = args[0]
	    decorators.each do |decorator_name|
	    	
	    	case decorator_name
	    		when 'page'
	    			result = PagesFilterDecorator.new(result)
	    		when 'title'
	    			result = TitleFilterDecorator.new(result)
	    		when 'fril'
	    			result = FrilFilterDecorator.new(result)
	    		when 'year'
	    			result = YearFilterDecorator.new(result)
	    	end
	    end
	    
	    result
	  end 
	end
end