module Bibmix
	
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
		if Bibmix.get_config('logging')
			classname = obj.class.to_s.split('::').last
			Rails.logger.info("#{classname}: #{message}.")
		end
	end
end

require 'dbc'
require 'amatch'
require 'decorator'

require 'bibmix/error'
require 'bibmix/abstract/request'
require 'bibmix/abstract/referencecollector'
require 'bibmix/abstract/enrichmenthandler'
require 'bibmix/abstract/reference'
require 'bibmix/abstract/cmeapplication'
require 'bibmix/abstract/referenceintegrator'
require 'bibmix/abstract/response'
require 'bibmix/abstract/referencevalidator'
require 'bibmix/abstract/pipeline'
require 'bibmix/abstract/metadataprocessor'

require 'bibmix/metadataprocessor/parscitmetadataprocessor'

require 'bibmix/referencevalidator/authorattributevalidator'
require 'bibmix/referencevalidator/titleattributevalidator'
require 'bibmix/referencevalidator/mergedbibsonomytitlequeryvalidator'

require 'bibmix/reference'
require 'bibmix/collectedreference'
require 'bibmix/filteredreference'
require 'bibmix/parscit'
require 'bibmix/cacherequest'
require 'bibmix/filterdecoratorfactory'
require 'bibmix/chaintoken'
require 'bibmix/referencefilter'
require 'bibmix/pipeline'


require 'bibmix/referenceintegrator/naivereferenceintegrator'
require 'bibmix/referenceintegrator/intelligentreferenceintegrator'

require 'bibmix/filterdecorator/frilfilterdecorator'
require 'bibmix/filterdecorator/pagesfilterdecorator'
require 'bibmix/filterdecorator/titlefilterdecorator'
require 'bibmix/filterdecorator/yearfilterdecorator'

require 'bibmix/bibsonomy/abstract/query'
require 'bibmix/bibsonomy/request'
require 'bibmix/bibsonomy/xmlresponse'
require 'bibmix/bibsonomy/titlequery'
require 'bibmix/bibsonomy/authorquery'
require 'bibmix/bibsonomy/enrichmenthandler/titlequeryenrichmenthandler'
require 'bibmix/bibsonomy/enrichmenthandler/authorqueryenrichmenthandler'

require 'bibmix/ccsb/abstract/query'
require 'bibmix/ccsb/response'
require 'bibmix/ccsb/request'
require 'bibmix/ccsb/titlequery'
require 'bibmix/ccsb/enrichmenthandler/titlequeryenrichmenthandler'

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
