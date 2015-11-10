require 'rails_helper'
require './lib/logic/extract'

describe 'extraction of structure files' do

  before do
    @extractor = Extractor.new()
  end

  LEGI_ROOT_PATH = './spec/lib/logic/legi/'

  describe 'with a directory with 3 structure files' do
    it "extrait 3 path" do
      expect(@extractor.load_structure_xmls(LEGI_ROOT_PATH).length).to eq(3)
    end
  end

  describe 'when we have one structure file' do
    it 'extracts the section link code correctly' do
      struct_file = LEGI_ROOT_PATH + 'LEGITEXT000005627819/texte/struct/LEGITEXT000005627819.xml'
      section_links = @extractor.get_section_links_content(@extractor.get_section_links(@extractor.load_xml (struct_file)))
      expect(section_links.length).to  eq(7)
      expect(section_links[0]).to  eq("PREMIÈRE PARTIE : DISPOSITIONS APPLICABLES AUX POUVOIRS ADJUDICATEURS")
    end
  end

  describe 'when we have one structure file' do
    before do
      @xml = <<-FOO
  <?xml version="1.0" encoding="UTF-8"?>
  <TEXTELR>
  <STRUCT>
  <LIEN_SECTION_TA cid="LEGISCTA000006083133" debut="2006-09-01" etat="VIGUEUR" fin="2999-01-01" id="LEGISCTA000006083133" niv="1" url="/LEGI/SCTA/00/00/06/08/31/LEGISCTA000006083133.xml">PREMIÈRE PARTIE : DISPOSITIONS APPLICABLES AUX POUVOIRS ADJUDICATEURS</LIEN_SECTION_TA>
  <LIEN_SECTION_TA cid="LEGISCTA000006083134" debut="2006-09-01" etat="VIGUEUR" fin="2999-01-01" id="LEGISCTA000006083134" niv="1" url="/LEGI/SCTA/00/00/06/08/31/LEGISCTA000006083134.xml">DEUXIÈME PARTIE : DISPOSITIONS APPLICABLES AUX ENTITÉS ADJUDICATRICES</LIEN_SECTION_TA>
  <LIEN_SECTION_TA cid="LEGISCTA000006083135" debut="2006-09-01" etat="MODIFIE" fin="2011-09-16" id="LEGISCTA000006083135" niv="1" url="/LEGI/SCTA/00/00/06/08/31/LEGISCTA000006083135.xml">TROISIÈME PARTIE : DISPOSITIONS DIVERSES.</LIEN_SECTION_TA>
  <LIEN_SECTION_TA cid="LEGISCTA000006083135" debut="2011-09-16" etat="VIGUEUR" fin="2999-01-01" id="LEGISCTA000024564195" niv="1" url="/LEGI/SCTA/00/00/24/56/41/LEGISCTA000024564195.xml">TROISIÈME PARTIE : DISPOSITIONS APPLICABLES AUX MARCHÉS DE DÉFENSE OU DE SÉCURITÉ.</LIEN_SECTION_TA>
  <LIEN_SECTION_TA cid="LEGISCTA000019032497" debut="2008-06-22" etat="MODIFIE" fin="2011-09-16" id="LEGISCTA000019033310" niv="1" url="/LEGI/SCTA/00/00/19/03/33/LEGISCTA000019033310.xml">QUATRIÈME PARTIE : DISPOSITIONS APPLICABLES AUX COLLECTIVITÉS D'OUTRE-MER.</LIEN_SECTION_TA>
  <LIEN_SECTION_TA cid="LEGISCTA000019032497" debut="2011-09-16" etat="VIGUEUR" fin="2999-01-01" id="LEGISCTA000024564151" niv="1" url="/LEGI/SCTA/00/00/24/56/41/LEGISCTA000024564151.xml">QUATRIÈME PARTIE : MARCHÉS MIXTES.</LIEN_SECTION_TA>
  <LIEN_SECTION_TA cid="LEGISCTA000024561989" debut="2011-09-16" etat="VIGUEUR" fin="2999-01-01" id="LEGISCTA000024561992" niv="1" url="/LEGI/SCTA/00/00/24/56/19/LEGISCTA000024561992.xml">CINQUIÈME PARTIE : DISPOSITIONS APPLICABLES AUX COLLECTIVITÉS D'OUTRE-MER.</LIEN_SECTION_TA>
  </STRUCT>
  </TEXTELR>
      FOO
    end

    it 'create the section model for one structure file' do
      @extractor.extract_section_links_one_struct_xml(Nokogiri.Slop(@xml))
      expect(Section.all.length).to eq(7)
    end
  end
end