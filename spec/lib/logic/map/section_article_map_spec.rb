require './lib/logic/map/link_article_section_map'

def fake_section_article_link
  '<LIEN_ART debut="2002-03-28" etat="MODIFIE" fin="2002-12-14" id="LEGIARTI000006391999" num="L3534-7" origine="LEGI"/>'
end


describe 'mapping of sections article links' do

  describe "when we have one section link" do

    before do
      @link_section_article_map = LinkArticleSectionMap.parse(fake_section_article_link)
    end

    it 'maps correctly the section article link' do
      expect(@link_section_article_map.state).to             eq("MODIFIE")
      expect(@link_section_article_map.start_date).to        eq("2002-03-28")
      expect(@link_section_article_map.end_date).to          eq("2002-12-14")
      expect(@link_section_article_map.target_id_article_origin).to eq("LEGIARTI000006391999")
    end

  end

end