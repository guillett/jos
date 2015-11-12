require 'rails_helper'
require './lib/logic/extract'
require './lib/logic/section_map'
require './lib/logic/struct_map'

def fake_struct_file section, nb_of_link
  header = <<-FOO
  <?xml version="1.0" encoding="UTF-8"?>
  <TEXTELR>
  <STRUCT>
  FOO

  body = ""

  nb_of_link.times do
    body += "<LIEN_SECTION_TA cid='LEGISCTA000006083133' debut='#{section[:start_date]}' etat='#{section[:state]}' fin='#{section[:end_date]}' id='#{section[:id_section_origin]}' niv='#{section[:level]}' url='/LEGI/SCTA/00/00/06/08/31/LEGISCTA000006083133.xml'>#{section[:title]}</LIEN_SECTION_TA>"
  end

  footer = <<-FOO
  </STRUCT>
  </TEXTELR>
  FOO
  header + body + footer
end


describe 'mapping of sections links' do

  describe "when we have one section link" do

    before do
      @xml = Nokogiri.Slop(fake_struct_file({   id_section_origin: "LEGISCTA000006083133",
                                                title: "PREMIÈRE PARTIE : DISPOSITIONS APPLICABLES AUX POUVOIRS ADJUDICATEURS",
                                                level: 1,
                                                state: "VIGUEUR",
                                                start_date: "2006-09-01",
                                                end_date: "2999-01-01"}, 1))
      @structMap = StructMap.parse(@xml, :single => true)
    end

    it 'maps correctly the section link' do
      sectionLinkHash = @structMap.sections.first.to_hash
      expect(sectionLinkHash["title"]).to  eq("PREMIÈRE PARTIE : DISPOSITIONS APPLICABLES AUX POUVOIRS ADJUDICATEURS")
      expect(sectionLinkHash["niv"]).to  eq(1)
      expect(sectionLinkHash["etat"]).to  eq("VIGUEUR")
      expect(sectionLinkHash["debut"]).to  eq("2006-09-01")
      expect(sectionLinkHash["fin"]).to  eq("2999-01-01")
      expect(sectionLinkHash["id"]).to  eq("LEGISCTA000006083133")
    end

  end

end


