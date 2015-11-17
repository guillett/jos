require 'rails_helper'
require './lib/logic/extract'
require './lib/logic/map/section_map'
require './lib/logic/map/struct_map'

def fake_struct_file section, nb_of_link
  body = ''
  nb_of_link.times do
    body += "<LIEN_SECTION_TA cid='LEGISCTA000006083133' debut='#{section[:start_date]}' etat='#{section[:state]}' fin='#{section[:end_date]}' id='#{section[:id_section_origin]}' niv='#{section[:level]}' url='/LEGI/SCTA/00/00/06/08/31/LEGISCTA000006083133.xml'>#{section[:title]}</LIEN_SECTION_TA>"
  end
  body
end


describe 'mapping of sections links' do

  describe "when we have one section link" do

    before do
      @xml = fake_struct_file({   id_section_origin: "LEGISCTA000006083133",
                                                title: "PREMIÈRE PARTIE : DISPOSITIONS APPLICABLES AUX POUVOIRS ADJUDICATEURS",
                                                level: 1,
                                                state: "VIGUEUR",
                                                start_date: "2006-09-01",
                                                end_date: "2999-01-01",
                                                id_section_parent_origin: "LEGITEXT000005627819"},
                                            1)

      @sectionLinkHash = SectionMap.parse(@xml, :single => true).to_hash
    end

    it 'maps correctly the section link' do
      expect(@sectionLinkHash["title"]).to                    eq("PREMIÈRE PARTIE : DISPOSITIONS APPLICABLES AUX POUVOIRS ADJUDICATEURS")
      expect(@sectionLinkHash["level"]).to                    eq(1)
      expect(@sectionLinkHash["state"]).to                    eq("VIGUEUR")
      expect(@sectionLinkHash["start_date"]).to               eq("2006-09-01")
      expect(@sectionLinkHash["end_date"]).to                 eq("2999-01-01")
      expect(@sectionLinkHash["id_section_origin"]).to        eq("LEGISCTA000006083133")
    end

    it 'create correctly the section model' do
      section = Section.new(@sectionLinkHash)
      expect(section.title).to                    eq("PREMIÈRE PARTIE : DISPOSITIONS APPLICABLES AUX POUVOIRS ADJUDICATEURS")
      expect(section.level).to                    eq(1)
      expect(section.state).to                    eq("VIGUEUR")
      expect(section.start_date).to               eq("2006-09-01")
      expect(section.end_date).to                 eq("2999-01-01")
      expect(section.id_section_origin).to        eq("LEGISCTA000006083133")
    end

  end

end


