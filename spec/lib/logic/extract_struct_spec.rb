require 'rails_helper'
require './lib/logic/extract'

describe 'extraction of structure files' do

  LEGI_ROOT_PATH = './spec/lib/logic/legi/'

  describe 'with a directory with 3 structure files' do
    it "extrait 3 path" do
      expect(load_structure_xmls(LEGI_ROOT_PATH).length).to eq(3)
    end
  end

  describe 'when we have one structure file' do
    it 'extracts the section link code correctly' do
      struct_file = LEGI_ROOT_PATH + 'LEGITEXT000005627819/texte/struct/LEGITEXT000005627819.xml'
      section_links = get_section_links_content(get_section_links(load_xml (struct_file)))
      expect(section_links.length).to  eq(7)
      expect(section_links[0]).to  eq("PREMIÈRE PARTIE : DISPOSITIONS APPLICABLES AUX POUVOIRS ADJUDICATEURS")
    end
  end


end