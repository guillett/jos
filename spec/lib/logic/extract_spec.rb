require 'rails_helper'
require './lib/logic/extract'
require './lib/logic/map/legiscta_map'

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

  it 'escape title nicely' do
    expect(@extractor.escape_title("Code de l'entrée (tip,top) du séjour.()")).to eq("code_de_l_entree_tip_top_du_sejour")
  end
end

describe '.extract_sections_and_articles' do

  before do
    allow(File).to receive(:read).with(anything()).and_return("")

    @legisctaMapInstanceMock = instance_double("LegisctaMap")
    LegisctaMapMock = class_double("LegisctaMap").as_stubbed_const()
    allow(LegisctaMapMock).to receive(:parse).with(anything(), anything()).and_return(@legisctaMapInstanceMock)

    allow(@legisctaMapInstanceMock).to receive(:id).and_return("1")
  end

  context 'with one section in Legiscta' do
    before do
      section = Section.new()
      allow(@legisctaMapInstanceMock).to receive(:extract_sections).and_return([section])
      allow(@legisctaMapInstanceMock).to receive(:extract_articles).with(anything()).and_return([])

      extractor = Extractor.new()
      @code = Code.new()
      extractor.extract_sections_and_articles([], @code, ["1"])
    end

    it 'add one section in the code' do
      expect(@code.sections.length).to eq(1)
    end
  end

  context 'with 2 articles belonging to two sections each in Legiscta' do
    before do
      a1 = Article.new()
      a2 = Article.new()

      allow(@legisctaMapInstanceMock).to receive(:extract_sections).and_return([])
      allow(@legisctaMapInstanceMock).to receive(:extract_articles).with(anything()).and_return([a1, a2])


      s1 = Section.new(id_section_origin: "1")
      s2 = Section.new(id_section_origin: "1")

      @code = Code.new()
      @code.sections += [s1,s2]

      extractor = Extractor.new()
      extractor.extract_sections_and_articles([], @code, ["1"])
    end

    it 'add two articles each 2 sections' do
      expect(@code.sections.length).to eq(2)

      expect(@code.sections[1].articles.length).to eq(2)
      expect(@code.sections[1].articles.length).to eq(2)
    end
  end

end