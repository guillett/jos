require 'rails_helper'

RSpec.describe Section, type: :model do

  describe ':with_article_displayable' do
    context 'when we have a section with no article' do
      before do
        section = Section.create(title: '1')
        @section_retrieved = Section.with_article_displayable section.id
      end

      it 'retrieve this section' do
        expect(@section_retrieved.title).to eq('1')
      end
    end

    context 'when we have a section with no article displayable' do
      before do
        article = Article.create(state: 'PLOP')
        section = Section.create(title: '1', articles: [article])
        @section_retrieved = Section.with_article_displayable section.id
      end

      it 'retrieve this section' do
        expect(@section_retrieved.title).to eq('1')
      end

      it 'retrieve no article' do
        expect(@section_retrieved.articles.length).to eq(0)
      end

    end

    context 'when we have a section with one article VIGUEUR' do
      before do
        article = Article.create(state: 'VIGUEUR')
        section = Section.create(title: '1', articles: [article])
        @section_retrieved = Section.with_article_displayable section.id
      end

      it 'retrieve this section' do
        expect(@section_retrieved.title).to eq('1')
      end

      it 'retrieve the article' do
        expect(@section_retrieved.articles.length).to eq(1)
      end
    end
  end

  context 'when we have a section with one article ABROGE_DIFF' do
    before do
      article = Article.create(state: 'ABROGE_DIFF')
      section = Section.create(title: '1', articles: [article])
      @section_retrieved = Section.with_article_displayable section.id
    end

    it 'retrieve this section' do
      expect(@section_retrieved.title).to eq('1')
    end

    it 'retrieve the article' do
      expect(@section_retrieved.articles.length).to eq(1)
    end
  end
end