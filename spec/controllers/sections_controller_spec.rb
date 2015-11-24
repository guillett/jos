require 'rails_helper'

RSpec.describe SectionsController, type: :controller do

  describe '.show' do

    context 'with 3 articles in different states' do

      before do
        article1 = Article.create()
        article2 = Article.create()
        article3 = Article.create()

        code = Code.create()

        section = Section.create(code: code)
        sal_1 = SectionArticleLink.create(section: section, article: article1, state: 'VIGUEUR')
        sal_2 = SectionArticleLink.create(section: section, article: article2, state: 'ABROGE_DIFF')
        sal_3 = SectionArticleLink.create(section: section, article: article3)

        section.section_article_links << sal_1 << sal_2 << sal_3
        section.save()

        get :show, id: section.id
      end

      it "preloads only article in VIGUEUR or ABROGE_DIFF" do
        expect( assigns[:articles].length).to eq(2)
      end


    end

  end

end
