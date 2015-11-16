require 'rails_helper'
require './lib/logic/extract'

describe 'extraction of text folders' do

  before do
    @extractor = Extractor.new()
  end

  LEGI_ROOT_PATH = './spec/lib/logic/legi/legi_example'

  describe 'with a directory with 3 text folder' do
    it "extracts text folders" do
      expect(@extractor.extract_text_folder_paths(LEGI_ROOT_PATH).length).to eq(3)
    end
  end

  describe 'with a directory with 2 section_ta' do
    it "extracts 2 section_ta" do
      expect(@extractor.extract_sections_ta_xml_paths(LEGI_ROOT_PATH + "/LEGITEXT000005627819").length).to eq(2)
    end
  end

end

describe 'escape title' do
  before do
    @extractor = Extractor.new()
  end

  it 'escpapge title nicely' do
    expect(@extractor.escape_title("Code de l'entrée (tip,top) du séjour.()")).to eq("code_de_l_entree_tip_top_du_sejour")
  end
end