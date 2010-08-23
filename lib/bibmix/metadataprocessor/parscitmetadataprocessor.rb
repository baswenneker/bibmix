require 'bibmix'

module Bibmix
	class ParscitMetadataProcessor
		include Bibmix::MetadataProcessorAbstract, DesignByContract
		
		pre(	'Parameter metadata should be a hash') {|metadata| citation_string.is_a?(String) || citation_string.eql?('')}
		post( 'Return value should be a Bibmix::AbstractReference instance') {|result, metadata| result.is_a?(Bibmix::AbstractReference)}
		def self.process_metadata(metadata)
	    
	    metadata['author'] = metadata['authors']['author']
	    
	    if metadata['date'] =~ /^\d{4}$/
	    	metadata['year'] = metadata['date']
	    end
	    
	    Bibmix::Reference.from_hash(metadata)
	  end
	end
end