require 'rails_helper'
require './lib/logic/extract'
require './lib/logic/map/section_map'
require './lib/logic/map/legiscta_map'

describe 'mapping of sections links' do

  def fake_scta_file
    <<-FOO
<?xml version="1.0" encoding="UTF-8"?>
<SECTION_TA>
  <ID>LEGISCTA000006088000</ID>
  <TITRE_TA>Partie législative</TITRE_TA>
  <STRUCTURE_TA>
    <LIEN_SECTION_TA cid="LEGISCTA000006116627" debut="1996-02-24" etat="VIGUEUR" fin="2999-01-01" id="LEGISCTA000006116627" niv="2" url="/LEGI/SCTA/00/00/06/11/66/LEGISCTA000006116627.xml">PREMIÈRE PARTIE : DISPOSITIONS GÉNÉRALES</LIEN_SECTION_TA>
    <LIEN_SECTION_TA cid="LEGISCTA000024405340" debut="2222-02-22" etat="VIGUEUR_DIFF" fin="2999-01-01" id="LEGISCTA000024405340" niv="2" url="/LEGI/SCTA/00/00/24/40/53/LEGISCTA000024405340.xml">SEPTIEME PARTIE : AUTRES COLLECTIVITES REGIES PAR L'ARTICLE 73 DE LA CONSTITUTION</LIEN_SECTION_TA>
  </STRUCTURE_TA>
  <CONTEXTE>
    <TEXTE autorite="" cid="LEGITEXT000006070633" date_publi="2999-01-01" date_signature="2999-01-01" ministere="" nature="CODE" nor="" num="">
      <TITRE_TXT c_titre_court="Code général des collectivités territoriales" debut="1996-02-24" fin="2999-01-01" id_txt="LEGITEXT000006070633">Code général des collectivités territoriales</TITRE_TXT>
    </TEXTE>
  </CONTEXTE>
</SECTION_TA>
    FOO
  end


  describe "when we have a scta file with two section link" do

    before do
      @legisctaMap = LegisctaMap.parse(fake_scta_file, :single => true)
    end

    it 'maps correctly two section link' do
      expect(@legisctaMap.sections.length).to eq(2)
    end

    it 'maps correctly the id' do
      expect(@legisctaMap.id).to eq("LEGISCTA000006088000")
    end

  end

end


