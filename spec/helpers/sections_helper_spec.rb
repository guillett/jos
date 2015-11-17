require 'rails_helper'

RSpec.describe SectionsHelper, type: :helper do
  describe "display summary" do

    before do
      article1 = Article.create({id_article_origin: "LEGIARTI000024562054"})
      article2 = Article.create({id_article_origin: "LEGIARTI000006204469"})
      articles = [article1, article2]

      @summary = display_summary(articles)
    end

    it "display one ul and as many li as article" do
      expect(@summary).to eq("<ul><li>LEGIARTI000024562054</li><li>LEGIARTI000006204469</li></ul>")
    end

  end
end
