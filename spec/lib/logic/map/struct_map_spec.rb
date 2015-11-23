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


  context "when we have a struct file with two link sections" do

    before do
      @structMap = StructMap.parse(fake_struct_file, :single => true)
    end

    it 'maps correctly two section link' do
      expect(@structMap.section_links.length).to eq(2)
    end

    it 'maps correctly the id' do
      expect(@structMap.id_section_origin).to eq("LEGITEXT000005627819")
    end

    describe ".to_section_links_hash" do
      before do
        @section_links = @structMap.to_section_links_hash()
      end

      it 'extracts 2 section links' do
        expect(@section_links.length).to eq(2)
        section1 = @section_links.select{|sl| sl["target_id_section_origin"] == 'LEGISCTA000006083134' }.first
        expect(section1["order"]).to eq(1)
        expect(section1["source_id_section_origin"]).to eq("LEGITEXT000005627819")
      end

    end
  end

end