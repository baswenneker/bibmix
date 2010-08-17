require 'bib2'

module Bib2
	class Parscit < Bib2::AbstractCMEApplication
		
		def parse(str)
			@citation = str
			
			if str.nil? || str.eql?("")
      	raise Bib2::Error, 'Citation string is nil or empty.'
    	end
    
	    parscit_cmd = Bib2::get_config('parscit_cmd')
	    	    
	    # Convert the passed string to UTF-8, this prevents possible
	    # seg faults in parseRefStrings.pl.
	    ic = Iconv.new('UTF-8//IGNORE', 'UTF-8')
	    valid_string = ic.iconv(str << ' ')[0..-2]
	    
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
	    ref['citation'] = str
	    ref['parser'] = 'parscit'
	    
	    Bib2::Reference.from_hash(ref)
	  end
	end
end