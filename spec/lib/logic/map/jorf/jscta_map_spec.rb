require 'rails_helper'
require './lib/logic/map/jorf/jscta_map'

def fake_jscta_file
  <<-FOO
<SECTION_TA>
<ID>JORFSCTA000030611457</ID>
<TITRE_TA>Titre Ier : MODALITÉS D'ADMISSION</TITRE_TA>
<COMMENTAIRE/>
<STRUCTURE_TA>
<LIEN_ART debut="2999-01-01" etat="" fin="2999-01-01" id="JORFARTI000030611462" num="3" origine="JORF"/>
<LIEN_ART debut="2999-01-01" etat="" fin="2999-01-01" id="JORFARTI000030611463" num="4" origine="JORF"/>
<LIEN_ART debut="2999-01-01" etat="" fin="2999-01-01" id="JORFARTI000030611464" num="5" origine="JORF"/>
<LIEN_ART debut="2999-01-01" etat="" fin="2999-01-01" id="JORFARTI000030611465" num="6" origine="JORF"/>
<LIEN_SECTION_TA cid="JORFSCTA000000905382" debut="2999-01-01" etat="" fin="2999-01-01" id="JORFSCTA000000905382" niv="2" url="/JORF/SCTA/00/00/00/90/53/JORFSCTA000000905382.xml">Chapitre Ier :   Concours de spécialité mathématiques</LIEN_SECTION_TA>
<LIEN_SECTION_TA cid="JORFSCTA000000905383" debut="2999-01-01" etat="" fin="2999-01-01" id="JORFSCTA000000905383" niv="2" url="/JORF/SCTA/00/00/00/90/53/JORFSCTA000000905383.xml">Chapitre II :   Concours de spécialité économie</LIEN_SECTION_TA>
</STRUCTURE_TA>
<CONTEXTE>
<TEXTE autorite="" cid="JORFTEXT000030611453" date_publi="2015-05-19" date_signature="2015-05-11" ministere="Ministère de l'économie, de l'industrie et du numérique" nature="ARRETE" nor="EING1505034A" num="">
<TITRE_TXT c_titre_court="ARRÊTÉ du 11 mai 2015" debut="2015-05-20" fin="2999-01-01" id_txt="LEGITEXT000030612416">Arrêté du 11 mai 2015 fixant les conditions d'admission, d'études et de délivrance des diplômes des cycles de formations d'ingénieur de spécialité de l'Ecole nationale supérieure des mines de Saint-Etienne</TITRE_TXT>
<TITRE_TXT c_titre_court="ARRÊTÉ du 11 mai 2015" debut="2999-01-01" fin="2999-01-01" id_txt="JORFTEXT000030611453">Arrêté du 11 mai 2015 fixant les conditions d'admission, d'études et de délivrance des diplômes des cycles de formations d'ingénieur de spécialité de l'Ecole nationale supérieure des mines de Saint-Etienne</TITRE_TXT>
</TEXTE>
</CONTEXTE>
</SECTION_TA>
  FOO
end

describe 'mapping of jscta' do

  context "when we have one jscta" do

    before do
      @xml = fake_jscta_file
      @jscta_map = JsctaMap.parse(@xml, :single => true)
      @jsection = @jscta_map.to_jsection
    end

    it 'maps correctly the jscta' do
      expect(@jsection.id_jsection_origin).to  eq("JORFSCTA000030611457")
      expect(@jsection.title).to   eq("Titre Ier : MODALITÉS D'ADMISSION")
    end

    it 'maps correctly the cont jorf link' do
      expect(@jscta_map.link_section_article_maps.length).to  eq(4)
      expect(@jscta_map.link_section_article_maps[0].id_jarticle_origin).to  eq("JORFARTI000030611462")
      expect(@jscta_map.link_section_article_maps[0].number).to  eq(3)
    end

    it 'maps correctly the jsection' do
      expect(@jscta_map.link_section_maps.length).to  eq(2)
      expect(@jscta_map.link_section_maps[0].id_jsection_origin).to  eq("JORFSCTA000000905382")
    end

    describe "to_jscta_jarticle_link_hashes" do

      before do
        @hashes = @jscta_map.to_jscta_jarticle_link_hashes
      end

      it 'hash correctly the link' do
        expect(@hashes.length).to   eq(4)
        expect(@hashes[0][:id_jsection_origin]).to   eq("JORFSCTA000030611457")
        expect(@hashes[0][:id_jarticle_origin]).to   eq("JORFARTI000030611462")
        expect(@hashes[0][:number]).to   eq(3)
      end
    end

  end

end


