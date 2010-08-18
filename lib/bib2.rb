module Bib2
	
	CONFIGURATION_CLASS = 'default'
	CONFIGURATION_FILE = "#{File.dirname(__FILE__)}/config/config.yml"
	
	def self.get_config(key, default=false)
		
		if @config.nil?
			@config = YAML.load_file(CONFIGURATION_FILE)[CONFIGURATION_CLASS]
			
			@config.each do |k, v|
        if v.is_a?(String)
          v = v.gsub(/__TMP_DIR__/, "#{Rails.root}/tmp")
          v = v.gsub(/__FRIL_DIR__/, "#{File.dirname(__FILE__)}/config/fril")
          v = v.gsub(/__EVALUATION_DIR__/, "#{File.dirname(__FILE__)}/../evaluation")
          v = v.gsub(/__PARSCIT_DIR__/, @config['parscit_dir'])          
        end
        @config[k] = v
      end   
			
		end

		if @config.has_key?(key)
			return @config[key]
		end
		
		default
	end
	
	# Use the rails logger to log certain messages.
	def self.log(obj, message)
		if Bib2.get_config('logging')
			classname = obj.class.to_s.split('::').last
			Rails.logger.info("#{classname}: #{message}.")
		end
	end
end

require 'dbc'

#require 'bib2/interface/enrichmenthandler'

require 'bib2/error'
require 'bib2/abstract/request'
require 'bib2/abstract/referencecollector'
require 'bib2/abstract/enrichmenthandler'
require 'bib2/abstract/reference'
require 'bib2/abstract/cmeapplication'
require 'bib2/abstract/referenceintegrator'
require 'bib2/abstract/response'


require 'bib2/reference'
require 'bib2/collectedreference'
require 'bib2/filteredreference'
require 'bib2/parscit'
require 'bib2/cacherequest'
require 'bib2/filterdecoratorfactory'
require 'bib2/chaintoken'
require 'bib2/referencefilter'
require 'bib2/naivereferenceintegrator'

require 'bib2/filterdecorator/frilfilterdecorator'
require 'bib2/filterdecorator/pagesfilterdecorator'
require 'bib2/filterdecorator/titlefilterdecorator'
require 'bib2/filterdecorator/yearfilterdecorator'

require 'bib2/bibsonomy/query'
require 'bib2/bibsonomy/request'
require 'bib2/bibsonomy/xmlresponse'
require 'bib2/bibsonomy/titlequery'
require 'bib2/bibsonomy/authorquery'
require 'bib2/bibsonomy/enrichmenthandler/titlequeryenrichmenthandler'
require 'bib2/bibsonomy/enrichmenthandler/authorqueryenrichmenthandler'

require 'bib2/recordlinker'

#require 'amatch'
#require 'decorator'
#require 'bibmix/error'
#require 'bibmix/query'
#require 'bibmix/recordlinker'
#require 'bibmix/record'
#require 'bibmix/request'
#require 'bibmix/cacherequest'
#require 'bibmix/chain'
#require 'bibmix/response'
#require 'bibmix/tokenizer'
