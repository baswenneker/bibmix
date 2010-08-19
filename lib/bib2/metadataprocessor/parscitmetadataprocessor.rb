require 'bib2'

module Bib2
	class ParscitMetadataProcessor
		include Bib2::MetadataProcessorAbstract, DesignByContract
		
		pre(	'Parameter metadata should be a hash') {|metadata| citation_string.is_a?(String) || citation_string.eql?('')}
		post( 'Return value should be a Bib2::AbstractReference instance') {|result, metadata| result.is_a?(Bib2::AbstractReference)}
		def self.process_metadata(metadata)
	    Bib2::Reference.from_hash(metadata)
	  end
	end
end