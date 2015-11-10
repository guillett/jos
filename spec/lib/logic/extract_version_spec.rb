require 'rails_helper'
require './lib/logic/extract'

describe 'extraction of versions files' do

  LEGI_ROOT_PATH = './spec/lib/logic/legi/'

  describe 'with a directory with 3 version files' do
    it "extrait 3 path" do
      expect(load_version_xmls(LEGI_ROOT_PATH).length).to eq(3)
    end
  end

  describe 'when we have one version file' do
    it 'extracts the title code correctly' do
      version_file = LEGI_ROOT_PATH + 'LEGITEXT000005627819/texte/version/LEGITEXT000005627819.xml'
      code_titre = get_code_title(load_xml (version_file))
      expect(code_titre).to  eq('Code des marchés publics')
    end
  end

  describe 'when we have 3 version files but 2 uniq' do
    it 'extracts the 2 title code correctly' do
      codes_titres = get_code_titles(LEGI_ROOT_PATH)
      expect(codes_titres.length).to  eq(2)
    end
  end

  describe 'test local file' do
    before do
      @xml = <<-FOO
<?xml version="1.0" encoding="UTF-8"?>
<TEXTE_VERSION>
<META>
    <META_SPEC>
      <META_TEXTE_VERSION>
        <TITRE>Code des marchés publics</TITRE>
      </META_TEXTE_VERSION>
    </META_SPEC>
  </META>
</TEXTE_VERSION>
FOO
    end

    it 'extracts the title code correctly' do
      code_titre = get_code_title(Nokogiri.Slop(@xml))
      expect(code_titre).to  eq('Code des marchés publics')
    end

    it 'create the code model' do
      extract_codes(LEGI_ROOT_PATH)
      expect(Code.all.length).to eq(2)
      expect(Code.all.map{|c| c.title}).to contain_exactly('Code des marchés publics', "Code de la consommation") # pass
    end

  end

end