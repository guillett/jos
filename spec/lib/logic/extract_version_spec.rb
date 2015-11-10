require 'rails_helper'
require './lib/logic/extract'

def fake_version_file titre
  <<-FOO
<?xml version="1.0" encoding="UTF-8"?>
<TEXTE_VERSION>
<META>
    <META_SPEC>
      <META_TEXTE_VERSION>
        <TITRE>#{titre}</TITRE>
      </META_TEXTE_VERSION>
    </META_SPEC>
  </META>
</TEXTE_VERSION>
  FOO
end

describe 'extraction of versions files' do

  before do
    @extractor = Extractor.new()
  end

  LEGI_ROOT_PATH = './spec/lib/logic/legi/'

  describe 'with a directory with 3 version files' do
    it "extrait 3 path" do
      expect(@extractor.load_version_xmls(LEGI_ROOT_PATH).length).to eq(3)
    end
  end

  describe 'when we have one version file' do
    before do
      xml = Nokogiri.Slop(fake_version_file("Code des marchés publics"))
      allow(@extractor).to receive(:load_version_xmls) { [xml] }
    end

    it 'extracts the title code correctly' do
      @extractor.extract_codes("")
      expect(Code.first.title).to  eq('Code des marchés publics')
    end
  end

  describe 'when we have 3 version files but 2 with uniq title' do
    before do
      xml1 = Nokogiri.Slop(fake_version_file("1"))
      xml2 = Nokogiri.Slop(fake_version_file("2"))
      xml3 = Nokogiri.Slop(fake_version_file("2"))
      allow(@extractor).to receive(:load_version_xmls) { [xml1, xml2, xml3] }
    end

    it 'extracts the 2 title code correctly' do
      codes_titres = @extractor.get_code_titles(LEGI_ROOT_PATH)
      expect(codes_titres.length).to  eq(2)
    end
  end

end