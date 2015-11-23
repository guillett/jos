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

describe '.add_articles_to_sections' do

  before do
    @legisctaMapInstanceMock = instance_double("LegisctaMap")
    allow(@legisctaMapInstanceMock).to receive(:id).and_return("1")
  end


  context 'with 2 articles belonging to two sections each in Legiscta' do
    before do
      a1 = Article.new()
      a2 = Article.new()

      allow(@legisctaMapInstanceMock).to receive(:extract_articles).with(anything()).and_return([a1, a2])

      s1 = Section.new(id_section_origin: "1")
      s2 = Section.new(id_section_origin: "1")

      @code = Code.new()
      @code.sections += [s1,s2]

      extractor = Extractor.new()
      extractor.add_articles_to_sections(@code, @code, @legisctaMapInstanceMock)
    end

    it 'add two articles each 2 sections' do
      expect(@code.sections.length).to eq(2)

      expect(@code.sections[1].articles.length).to eq(2)
      expect(@code.sections[1].articles.length).to eq(2)
    end
  end

end


describe 'truc' do
  context 'yop' do

    before do
      @s1 = Section.create!()
      @s2 = Section.create!()
      @s3 = Section.create!()
      @s4 = Section.create!()
      SectionLink.create!(state: 'COOL', source: @s1, target: @s2)
      SectionLink.create!(state: 'OUAICH', source: @s1, target: @s3)
      SectionLink.create!(state: 'OUAICH', source: @s2, target: @s4)
    end

    it 'works' do
      expect(SectionLink.all.length).to eq(3)
      expect(SectionLink.first.state).to eq('COOL')
    end

    it 'works from section' do
      expect(@s1.section_links.length).to eq(2)
    end

    it "load easly what we want to be load" do
      buildIt Section.all, SectionLink.all

    end

    def buildIt sections, links
      sections_hash = sections.reduce({}) { |h, s| h[s.id]=s; h }

      pp sections_hash

      links.each do |l|
        source = sections_hash[l.source_id]
        target = sections_hash[l.target_id]
        l.source = source
        l.target = target
        source.section_links << l
      end
    end

  end

end