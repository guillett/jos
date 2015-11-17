require 'rails_helper'

RSpec.describe Section, type: :model do

  describe "#summary" do

    context "with a section with one article" do
      before do
        section = Section.new()
        @article = Article.new({id_article_origin: "LEGIARTI000024562054", state: 'VIGUEUR'})
        section.articles.push(@article)
        section.save()
        @summary = section.summary
      end

      it "displays one article" do
        expect(@summary).to eq([@article])
      end
    end

  end

end
