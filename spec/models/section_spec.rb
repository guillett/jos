require 'rails_helper'

RSpec.describe Section, type: :model do

  describe ".section_links_valid" do
    context 'with 2 sections_link in the wrong order' do
      before do
        @s1 = Section.new()
        s1_1 = Section.new()
        s1_2 = Section.new()

        sl1 = SectionLink.new(source:@s1, target:s1_1, order: 1, state: 'VIGUEUR')
        sl2 = SectionLink.new(source:@s1, target:s1_2, order: 2, state: 'VIGUEUR')

        @s1.section_links << sl2 << sl1
        @s1.save
      end

      it "loads the link in the right order" do
        expect(@s1.section_links_valid.first.order).to eq (1)
      end

    end
  end

  describe ".section_article_links_valid" do
    context 'with 2 section_article_links in the wrong order' do
      before do
        @s1 = Section.new()
        a1_1 = Article.new()
        a1_2 = Article.new()

        sal1 = SectionArticleLink.new(section:@s1, article:a1_1, order: 1, state: 'VIGUEUR')
        sal2 = SectionArticleLink.new(section:@s1, article:a1_2, order: 2, state: 'VIGUEUR')

        @s1.section_article_links << sal2 << sal1
        @s1.save
      end

      it "loads the link in the right order" do
        expect(@s1.section_article_links_valid.first.order).to eq (1)
      end

    end
  end

end