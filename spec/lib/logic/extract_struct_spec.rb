require 'rails_helper'
require './lib/logic/extract'

def fake_struct_file section
  <<-FOO
  <?xml version="1.0" encoding="UTF-8"?>
  <TEXTELR>
  <STRUCT>
  <LIEN_SECTION_TA cid="LEGISCTA000024561989" debut="#{section[:start_date]}" etat="#{section[:level]}" fin="#{section[:end_date]}" id="#{section[:id_section_origin]}" niv="#{section[:level]}" url="/LEGI/SCTA/00/00/24/56/19/LEGISCTA000024561992.xml">#{section[:title]}</LIEN_SECTION_TA>
  </STRUCT>
  </TEXTELR>
  FOO
end
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
    before do
      @xml = Nokogiri.Slop(fake_struct_file({ id_section_origin: "LEGISCTA000024561992",
                                              title: "PREMIÈRE PARTIE : DISPOSITIONS APPLICABLES AUX POUVOIRS ADJUDICATEURS",
                                              level: 1,
                                              state: "VIGUEUR",
                                              start_date: "2006-09-01",
                                              end_date: "2999-01-01"}))
      allow(@extractor).to receive(:load_structure_xmls) { [@xml] }
    end

    it 'extracts the section link content correctly' do
      section_links = @extractor.get_section_links_content(@extractor.get_section_links(@xml))
      expect(section_links.length).to  eq(1)
      expect(section_links[0]).to  eq("PREMIÈRE PARTIE : DISPOSITIONS APPLICABLES AUX POUVOIRS ADJUDICATEURS")
    end

    it 'create the section model for sections in level one' do
      @extractor.extract_section_links_one_struct_xml(@xml)
      expect(Section.all.length).to eq(1)
    end
  end
end