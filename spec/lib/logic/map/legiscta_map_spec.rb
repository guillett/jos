require 'rails_helper'
require './lib/logic/extract'
require './lib/logic/map/link_section_map'
require './lib/logic/map/legiscta_map'

describe 'mapping of sections links' do

  def fake_scta_file
    <<-FOO
<?xml version="1.0" encoding="UTF-8"?>
<SECTION_TA>
  <ID>LEGISCTA000006088000</ID>
  <TITRE_TA>Partie législative</TITRE_TA>
  <STRUCTURE_TA>
    <LIEN_ART debut="2002-03-28" etat="MODIFIE" fin="2002-12-14" id="1" num="L3534-7" origine="LEGI"/>
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


  describe "when we have a scta file with two section link and one article section link" do

    before do
      @legisctaMap = LegisctaMap.parse(fake_scta_file, :single => true)
    end

    it 'maps correctly two section link' do
      expect(@legisctaMap.sections.length).to eq(2)
    end

    it 'maps correctly one article section link' do
      expect(@legisctaMap.article_links.length).to eq(1)
    end

    it 'maps correctly the id' do
      expect(@legisctaMap.id).to eq("LEGISCTA000006088000")
    end

    it 'extracts 2 sections' do
      sections = @legisctaMap.extract_linked_sections()
      expect(sections.length).to eq(2)
    end

    it 'extracts 1 article' do
      article_map = ArticleMap.new()
      article_map.nota = "nota"
      article_map.text = "text"
      article_map.nature = "nature"
      article_map.id = '1'

      articles = @legisctaMap.extract_articles([article_map])
      expect(articles.length).to eq(1)
      expect(articles[0].text).to eq('text')
      expect(articles[0].nota).to eq('nota')
      expect(articles[0].nature).to eq('nature')
    end

    it 'extracts to section' do
      section = @legisctaMap.to_section
      expect(section.title).to eq('Partie législative')
      expect(section.id_section_origin).to eq('LEGISCTA000006088000')
    end

    it 'extracts to section_links_hash' do
      section_links_hash = @legisctaMap.to_section_links_hash
      expect(section_links_hash.length).to eq(2)
      section_link_1 = section_links_hash.find{|s| s['target_id_section_origin'] == 'LEGISCTA000006116627' }
      expect(section_link_1['order']).to eq(0)
      expect(section_link_1['source_id_section_origin']).to eq('LEGISCTA000006088000')
    end

  end

end


