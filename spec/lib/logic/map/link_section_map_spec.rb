require 'rails_helper'
require './lib/logic/extract'
require './lib/logic/map/link_section_map'
require './lib/logic/map/struct_map'

def fake_struct_file section
  "<LIEN_SECTION_TA cid='LEGISCTA000006083133' debut='#{section[:start_date]}' etat='#{section[:state]}' fin='#{section[:end_date]}' id='#{section[:id_section_origin]}' niv='1' url='/LEGI/SCTA/00/00/06/08/31/LEGISCTA000006083133.xml'>ANNEXE 1-3</LIEN_SECTION_TA>"
end


describe 'mapping of sections links' do

  describe "when we have one section link" do

    before do
      @xml = fake_struct_file({   id_section_origin: "LEGISCTA000006083133",
                                  state: "VIGUEUR",
                                  start_date: "2006-09-01",
                                  end_date: "2999-01-01"
                              })

      @sectionLinkHash = LinkSectionMap.parse(@xml, :single => true).to_hash
    end

    it 'maps correctly the section link' do
      expect(@sectionLinkHash["state"]).to                    eq("VIGUEUR")
      expect(@sectionLinkHash["start_date"]).to               eq("2006-09-01")
      expect(@sectionLinkHash["end_date"]).to                 eq("2999-01-01")
      expect(@sectionLinkHash["target_id_section_origin"]).to eq("LEGISCTA000006083133")
    end

  end

end


