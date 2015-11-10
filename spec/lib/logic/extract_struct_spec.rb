require 'rails_helper'
require './lib/logic/extract'

def fake_struct_file section, nb_of_link
  header = <<-FOO
  <?xml version="1.0" encoding="UTF-8"?>
  <TEXTELR>
  <STRUCT>
  FOO

  body = ""

  nb_of_link.times do
    body += "<LIEN_SECTION_TA cid='LEGISCTA000024561989' debut='#{section[:start_date]}' etat='#{section[:level]}' fin='#{section[:end_date]}' id='#{section[:id_section_origin]}' niv='#{section[:level]}' url='/LEGI/SCTA/00/00/24/56/19/LEGISCTA000024561992.xml'>#{section[:title]}</LIEN_SECTION_TA>"
  end

  footer = <<-FOO
  </STRUCT>
  </TEXTELR>
  FOO
  header + body + footer
end
describe 'extraction of structure files' do

  before do
    @extractor = Extractor.new()
  end

  describe 'when we have one structure file with one link' do
    before do
      @xml = Nokogiri.Slop(fake_struct_file({ id_section_origin: "LEGISCTA000024561992",
                                              title: "PREMIÈRE PARTIE : DISPOSITIONS APPLICABLES AUX POUVOIRS ADJUDICATEURS",
                                              level: 1,
                                              state: "VIGUEUR",
                                              start_date: "2006-09-01",
                                              end_date: "2999-01-01"}, 1))
    end


    it 'create the section model for sections in level one' do
      sections = @extractor.get_section_links_one_struct_xml(@xml)
      expect(sections.length).to eq(1)
    end
  end


  describe 'when we have one structure file with 2 links' do
    before do
      @xml = Nokogiri.Slop(fake_struct_file({ id_section_origin: "LEGISCTA000024561992",
                                              title: "PREMIÈRE PARTIE : DISPOSITIONS APPLICABLES AUX POUVOIRS ADJUDICATEURS",
                                              level: 1,
                                              state: "VIGUEUR",
                                              start_date: "2006-09-01",
                                              end_date: "2999-01-01"}, 2))
    end


    it 'create the section model for sections in level one' do
      sections = @extractor.get_section_links_one_struct_xml(@xml)
      expect(sections.length).to eq(2)
    end
  end


end