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

describe '.link_sections' do
  context 'with 2 section and one section_link_hash' do

    before do
      extractor = Extractor.new()
      @s1 = Section.new(id_section_origin: '1')
      @s2 = Section.new(id_section_origin: '2')
      section_link_hash = {
      'source_id_section_origin'=> '1', 'target_id_section_origin'=> '2',
      'state' => 'vigueur',
      'start_date' => DateTime.parse('1996-01-01'),
      'end_date' => DateTime.parse('1997-01-01'),
      'order' => 1
      }
      extractor.link_sections([@s1,@s2],[section_link_hash])
    end

    it 'links correctly the 2 sections' do
      expect(@s1.section_links.first.target).to be(@s2)
    end

    it "the link has all the value" do
      expect(@s1.section_links.first.state).to eq('vigueur')
      expect(@s1.section_links.first.start_date).to eq('1996-01-01')
      expect(@s1.section_links.first.end_date).to eq('1997-01-01')
      expect(@s1.section_links.first.order).to eq(1)
    end

  end
end

describe '.link_code_sections' do
  context 'with 2 section and one section_link_hash' do

    before do
      extractor = Extractor.new()
      @code = Code.new()
      @s1 = Section.new(id_section_origin: '1')
      @s2 = Section.new(id_section_origin: '2')
      section_link_hash = {
          'source_id_section_origin'=> 'idDuCode', 'target_id_section_origin'=> '1',
          'state' => 'vigueur',
          'start_date' => DateTime.parse('1996-01-01'),
          'end_date' => DateTime.parse('1997-01-01'),
          'order' => 1
      }
      extractor.link_code_sections(@code, [@s1,@s2],[section_link_hash])
    end

    it 'links correctly the 2 sections' do
      expect(@code.code_section_links.first.section).to be(@s1)
    end

    it "the link has all the value" do
      expect(@code.code_section_links.first.state).to eq('vigueur')
      expect(@code.code_section_links.first.start_date).to eq('1996-01-01')
      expect(@code.code_section_links.first.end_date).to eq('1997-01-01')
      expect(@code.code_section_links.first.order).to eq(1)
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