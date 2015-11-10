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

  describe "when we have one version file" do

    before do
      @xml = Nokogiri.Slop(fake_version_file("version_title"))
    end

    it 'extracts correctly the title' do
      expect(@extractor.get_code_title(@xml)).to  eq("version_title")
    end

  end

end