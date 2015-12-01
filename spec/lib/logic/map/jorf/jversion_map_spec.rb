require 'rails_helper'
require './lib/logic/map/jorf/keyword_map'
require './lib/logic/map/jorf/jversion_map'

describe 'mapping of jorf version file' do

  def fake_jversion_file
    <<-FOO
<TEXTE_VERSION>
	<META>
		<META_COMMUN>
			<ID>JORFTEXT000000339622</ID>
    </META_COMMUN>
		<META_SPEC>
			<META_TEXTE_VERSION>
				<MCS_TXT>
					<MC>DIRECTIVE CEE</MC>
        </MCS_TXT>
			</META_TEXTE_VERSION>
		</META_SPEC>
	</META>
</TEXTE_VERSION>
    FOO
  end


  context "when we have a version file with a keyword" do

    before do
      @jversionMap = JversionMap.parse(fake_jversion_file, :single => true)
    end

    it 'maps correctly the jtext id' do
      expect(@jversionMap.id_jtext_origin).to eq("JORFTEXT000000339622")
    end

    it 'maps correctly a keyword' do
      expect(@jversionMap.keywords.length).to eq(1)
    end

  end

end