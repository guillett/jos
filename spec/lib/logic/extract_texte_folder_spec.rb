require 'rails_helper'
require './lib/logic/extract'

describe 'extraction of text folders' do

  before do
    @extractor = Extractor.new()
  end

  LEGI_ROOT_PATH = './spec/lib/logic/legi/'

  describe 'with a directory with 3 text folder' do
    it "extracts text folders" do
      expect(@extractor.extract_text_folders(LEGI_ROOT_PATH).length).to eq(3)
    end

    it "extracts version file of 1 text folder" do
      expect(@extractor.load_one_version_xml(@extractor.extract_text_folders(LEGI_ROOT_PATH)[0]).TEXTE_VERSION.META.META_COMMUN.ID.content).to eq("LEGITEXT000005627819")
    end

    it "extracts structure file of 1 text folder" do
      expect(@extractor.load_one_structure_xml(@extractor.extract_text_folders(LEGI_ROOT_PATH)[0]).TEXTELR.META.META_COMMUN.ID.content).to eq("LEGITEXT000005627819")
    end

    it 'creates code and section models from version and structure files' do
      codes = @extractor.extract_codes_and_sections(LEGI_ROOT_PATH)
      expect(codes.length).to eq(2)
      expect(codes.first.sections.length).to eq(7)
      expect(codes.last.sections.length).to eq(3)
    end

  end

end