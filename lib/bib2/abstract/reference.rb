require 'bib2'

module Bib2
	
	class ReferenceError < Bib2::Error; end
	class ReferenceInvalidMergeParamError < ReferenceError;	end
	
	# Reference class which is a datawrapper and interchangeable format for data 
	# in the Bib2 application.
	class AbstractReference
		
		# An array of attributes names.
		@@attributes = [:merged]

		# Create getters and setters for the given attributes.
		attr_accessor *@@attributes
		
		# Returns an array of attributes of the record.
		def get_attributes
			@@attributes
		end
		
		def id
			raise Bib2::NotImplementedError
		end
		
		# Allows to loop over the attribute keys of the record.
		def each(&block)
			values = {}
			each_attribute do |attr|
				value = self.fetch(attr)
				if not value.nil?
					values[attr] = value
				end
			end
		  values.each &block
		end
		
		# Allows to loop over the attribute keys of the record.
		def each_attribute(&block)
		  @@attributes.each &block
		end
		
		# Returns the value given a key, or returns the default value.
		def get(key, default=nil)
			val = self.send(key)
			val || default
		end
		
		# Creates a record from a hash.
		def self.from_hash(hsh)
			record = self.new
			
			hsh.each do |key, value|
				begin
					if value.kind_of?(String)
						record.send("#{key}=", value.strip)
					else
						record.send("#{key}=", value)
					end
				rescue Bib2::ReferenceError => e
					Rails.logger.debug(e)
				end
					
			end
			
			record
		end
		
		def to_array
			
			result = []		
			self.each_attribute do |key|
				val = self.get(key, ' ')
				
				if !val.nil? && val.kind_of?(Array)
					val = val.join(' and ')
				end
				
				result << val
			end
			result
		end
		
		def method_missing(method, *args)
			
			if ENV["RAILS_ENV"] == "test"
				name = method.to_s
   			aname = name.sub("=","")
				
				if !@@attributes.include?(aname) || !@@attributes.include?(method)
		#			Rails.logger.debug "Method missing: (#{aname})"
				end
			end
			
		end
		
		# To string method for pretty printing the record.
		def to_s
			"<Bib2::Reference(#{@title})>"
		end
	end
end