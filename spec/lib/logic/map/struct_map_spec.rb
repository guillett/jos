require 'rails_helper'
require './lib/logic/map/link_section_map'
require './lib/logic/map/struct_map'

describe 'mapping of structure file' do

  def fake_struct_file
    <<-FOO
<TEXTELR>
  <META>
    <META_COMMUN>
      <ID>LEGITEXT000005627819</ID>
    </META_COMMUN>
  </META>
  <STRUCT>
    <LIEN_SECTION_TA cid="LEGISCTA000006083133" debut="2006-09-01" etat="VIGUEUR" fin="2999-01-01" id="LEGISCTA000006083133" niv="1" url="/LEGI/SCTA/00/00/06/08/31/LEGISCTA000006083133.xml">PREMIÈRE PARTIE : DISPOSITIONS APPLICABLES AUX POUVOIRS ADJUDICATEURS</LIEN_SECTION_TA>
    <LIEN_SECTION_TA cid="LEGISCTA000006083134" debut="2006-09-01" etat="VIGUEUR" fin="2999-01-01" id="LEGISCTA000006083134" niv="1" url="/LEGI/SCTA/00/00/06/08/31/LEGISCTA000006083134.xml">DEUXIÈME PARTIE : DISPOSITIONS APPLICABLES AUX ENTITÉS ADJUDICATRICES</LIEN_SECTION_TA>
  </STRUCT>
</TEXTELR>
    FOO
  end


  describe "when we have a struct file with two link sections" do

    before do
      @structMap = StructMap.parse(fake_struct_file, :single => true)
    end

    it 'maps correctly two section link' do
      expect(@structMap.sections.length).to eq(2)
    end

    it 'maps correctly the id' do
      expect(@structMap.id).to eq("LEGITEXT000005627819")
    end

    it 'extracts 2 sections' do
      sections = @structMap.extract_linked_sections()
      expect(sections.length).to eq(2)
    end

  end

end