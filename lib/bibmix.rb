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

require 'amatch'
require 'decorator'
require 'bibmix/error'
require 'bibmix/query'
require 'bibmix/recordmerger'
require 'bibmix/record'
require 'bibmix/request'
require 'bibmix/cacherequest'
require 'bibmix/chain'
require 'bibmix/response'
require 'bibmix/tokenizer'
