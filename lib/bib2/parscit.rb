require 'bib2'

module Bib2
	class Parscit
		include Bib2::CMEApplicationAbstract, DesignByContract
		
		pre(	'Parameter citation_string should be a string') {|citation_string| citation_string.is_a?(String) || citation_string.eql?('')}
		post( 'Return value should be a Bib2::AbstractReference instance') {|result, citation_string| result.is_a?(Bib2::AbstractReference)}
		post( 'Property @reference should be a Bib2::AbstractReference instance') {@reference.is_a?(Bib2::AbstractReference)}
		post(	'Property @citation should be a string') {@citation.is_a?(String) || @citation.eql?('')}
		def parse_citation(citation_string)
			@citation = citation_string
			    
	    parscit_cmd = Bib2::get_config('parscit_cmd')
	    	    
	    # Convert the passed string to UTF-8, this prevents possible
	    # seg faults in parseRefStrings.pl.
	    ic = Iconv.new('UTF-8//IGNORE', 'UTF-8')
	    valid_string = ic.iconv(citation_string << ' ')[0..-2]
	    
	    # The ParsCit executable only reads from file so create a
	    # temporary file and fill it with the citation string.
	    tmp = Tempfile.new("parscit_parser_tmp")
	    tmp.binmode
	    tmp.puts(valid_string)
	    tmp.close()
	    
	    xml = `perl "#{parscit_cmd}" "#{tmp.path()}"`	    
	    
			valid_xml = ic.iconv(xml)
	    hsh = Hash.from_xml(valid_xml)
	    ref = hsh['algorithm']['citationList']['citation']
	    
	    tmp.unlink
	    
	    if !ref.is_a?(Hash)
	      raise "Invalid citation datatype or no citations found (ln=#{ref.inspect})"
	    end
	    	    
	    ref['author'] = ref['authors']['author']
	    ref['citation'] = citation_string
	    ref['parser'] = 'parscit'
	    
	    @reference = Bib2::Reference.from_hash(ref)
	  end
	end
end