require './lib/logic/map/article_version_map'

def fake_article_version
  <<-FOO
  <VERSIONS><VERSION etat='MODIFIE'><LIEN_ART debut='2000-09-21' etat='MODIFIE' fin='2009-11-01' id='LEGIARTI000006219125' num='L110-1' origine='LEGI'/></VERSION></VERSIONS>
  FOO
end


describe 'mapping of article version' do

  describe "when we have one article version" do

    before do
      p fake_article_version
      @article_version_map = ArticleVersionMap.parse(fake_article_version, :single => true).to_hash
    end

    it 'maps correctly the article version' do
      p @article_version_map
      expect(@article_version_map["id_article_origin"]).to eq("LEGIARTI000006219125")
    end

  end

end