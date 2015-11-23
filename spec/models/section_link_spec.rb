require 'rails_helper'

RSpec.describe Article, type: :model do
  describe "Article" do
    before do
      @article_1 = Article.new()
      @article_2 = Article.new()
      @article_1.versions << @article_2
      @article_1.save()
    end

    it "retrieves fisrt version of 1 article" do
      article_1 = Article.find(@article_1.id)
      expect(article_1.versions.first).to eq(@article_2)
    end
  end
end
