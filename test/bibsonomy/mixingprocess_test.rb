require 'test_helper'
require 'bibmix/bibsonomy'

class BibmixBibsonomyMixingProcessTest < ActiveSupport::TestCase
    
#  def testValidEntry1
#  	
#  	reference = Bibsonomy::Record.from_hash({
#  		:citation => 'Isaac G. Councill, C. Lee Giles, Min-Yen Kan. (2008) ParsCit: An open-source CRF reference string parsing package. To appear in the proceedings of the Language Resources and Evaluation Conference (LREC 08), Marrakesh, Morrocco, May.',
#  		:author => 'Isaac G Councill and C Lee Giles and Min-Yen Kan',
#  		:title => 'Parscit An open-source CRF reference string parsing package',
#  		:year => '2008',
#  		:location => 'Marrakesh, Morrocco',
#  		:booktitle => 'in the proceedings of the Language Resources and Evaluation Conference (LREC 08'
#  	})
#  	  	
#		process = Bibsonomy::MatchingProcess.new(reference)
#		x = process.run
#	end
	
	def testValidEntry3
  	hash = {
  		:citation => 'Isaac G. Councill, C. Lee Giles, Min-Yen Kan. (2008) ParsCit: An open-source CRF reference string parsing package. To appear in the proceedings of the Language Resources and Evaluation Conference (LREC 08), Marrakesh, Morrocco, May.',
  		:author => 'Beate Krause and Robert Jäschke and Andreas Hotho and Gerd Stumme',
  		:title => 'Logsonomy - social information retrieval with logdata',
  		:year => '2008',
  		:location => 'Marrakesh, Morrocco',
  		:booktitle => 'in the proceedings of the Language Resources and Evaluation Conference (LREC 08'
  	}
  	
  	require 'bibmix/record'
  	reference = Bibmix::Record.from_hash(hash)
  	
  	#puts reference.title.pair_distance_similar('Visit me, click me, be my friend: An analysis of evidence networks of user relationships in Bibsonomy')
  	
		process = Bibmix::Bibsonomy::MixingProcess.new(reference)
		x = process.execute
		assert_not_nil x
		assert x.kind_of?(Bibmix::Record)
		puts x.to_yaml
	end
	
#	def testValidEntry2
#  	reference = Bibsonomy::Record.from_hash({
#  		:citation => 'Isaac G. Councill, C. Lee Giles, Min-Yen Kan. (2008) ParsCit: An open-source CRF reference string parsing package. To appear in the proceedings of the Language Resources and Evaluation Conference (LREC 08), Marrakesh, Morrocco, May.',
#  		:author => 'Geert-Jan Houben',
#  		:title => 'adsads',
#  		:year => '2008',
#  		:location => 'Marrakesh, Morrocco',
#  		:booktitle => 'in the proceedings of the Language Resources and Evaluation Conference (LREC 08'
#  	})
#  	
#		process = Bibsonomy::MatchingProcess.new(reference)
#		x = process.run
#	end
 	
end