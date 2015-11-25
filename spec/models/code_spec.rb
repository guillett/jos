require 'rails_helper'

RSpec.describe Code, type: :model do

  describe "summary" do

    describe "with a code with two sections vigueur and one not in vigueur" do
      before do
        code = Code.new()
        s1 = Section.new(title: '1')
        s2_old = Section.new(title: '2 old')
        s2 = Section.new(title: '2')
        code_section_link1 = CodeSectionLink.new(code: code, section: s1, state: "VIGUEUR")
        code_section_link2_old = CodeSectionLink.new(code: code, section: s2_old, state: "not in vigueur")
        code_section_link2 = CodeSectionLink.new(code: code, section: s2, state: "VIGUEUR")
        code.code_section_links << code_section_link1 << code_section_link2_old << code_section_link2
        code.sections << s1 << s2_old << s2
        code.save()
        @summary = code.summary
      end

      it "displays two sections" do
        expect(@summary.length).to eq(2)
      end
    end

    describe "with a code with 2 sections of level 1 in descending order" do
      before do
        code = Code.new()
        s1 = Section.new(title: '1')
        s2 = Section.new(title: '2')
        code_section_link1 = CodeSectionLink.new(code: code, section: s2, state: "VIGUEUR", order: 2)
        code_section_link2 = CodeSectionLink.new(code: code, section: s1, state: "VIGUEUR", order: 1)
        code.code_section_links << code_section_link1 << code_section_link2
        code.sections << s1 << s2
        code.save()
        @summary = code.summary
      end

      it "displays two sections in ascending order" do
        expect(@summary[0].title).to eq("1")
        expect(@summary[1].title).to eq("2")
      end
    end

    describe "with a code with 1 section of level 1 and two sections of level 2" do
      before do
        code = Code.new()
        s1 = Section.new(title: '1')
        s1_1 = Section.new(title: '1.1')
        s1_2 = Section.new(title: '1.2')
        code_section_link1   = CodeSectionLink.new(code: code, section: s1, state: "VIGUEUR")
        section_link1_1 = SectionLink.new(source: s1, target: s1_1, state: "VIGUEUR")
        section_link1_2 = SectionLink.new(source: s1, target: s1_2, state: "VIGUEUR")

        s1.section_links << section_link1_1 << section_link1_2

        code.code_section_links << code_section_link1
        code.sections << s1 << s1_1 << s1_2
        code.save()
        @summary = code.summary
      end

      it "display one section lvl1 and two lvl2" do
        expect(@summary.length).to eq(1)
        expect(@summary[0].section_links_preloaded.length).to eq(2)
        expect(@summary[0].section_links_preloaded[0].target.title).to eq("1.1")
        expect(@summary[0].section_links_preloaded[1].target.title).to eq("1.2")
      end

    end

  end

  describe '::with_sections_section_links_and_article_links' do
    context 'with 2 sections' do
      before do
        @code = Code.new()
        @s1 = Section.new()
        @s2 = Section.new()
        @code.sections << @s1 << @s2
        @code.save()
      end

      it 'load the 2 sections' do
        sections = @code.sections_with_valid_links
        expect(sections.length).to eq(2)
      end

      context 'with a section link' do
        before do
          sl = SectionLink.new(source: @s1, target: @s2, state: section_link_state)
          @s1.section_links << sl
          @s1.save
          @sections = @code.sections_with_valid_links
        end

        context 'in state VIGUEUR' do
          let(:section_link_state) { 'VIGUEUR' }

          it 'the section link' do
            expect(@sections[0].section_links_valid.length).to eq(1)
          end
        end

        context 'in state YOP' do
          let(:section_link_state) { 'YOP' }

          it 'does not load the section_link' do
            expect(@sections[0].section_links_valid.length).to eq(0)
          end
        end

        context 'in state ABROGE_DIFF' do
          let(:section_link_state) { 'ABROGE_DIFF' }

          it 'does load the link' do
            expect(@sections[0].section_links_valid.length).to eq(1)
          end
        end
      end

      context 'with a article section link' do
        before do
          a1 = Article.create()
          sal = SectionArticleLink.new(section: @s1, article: a1, state: section_article_link_state)
          @s1.section_article_links << sal
          @s1.save
          @sections = @code.sections_with_valid_links
        end

        context 'in state VIGUEUR' do
          let(:section_article_link_state) { 'VIGUEUR' }

          it 'the section link' do
            expect(@sections[0].section_article_links_valid.length).to eq(1)
          end
        end

        context 'in state YOP' do
          let(:section_article_link_state) { 'YOP' }

          it 'does not load the section_link' do
            expect(@sections[0].section_article_links_valid.length).to eq(0)
          end
        end

        context 'in state ABROGE_DIFF' do
          let(:section_article_link_state) { 'ABROGE_DIFF' }

          it 'does load the link' do
            expect(@sections[0].section_article_links_valid.length).to eq(1)
          end
        end
      end

    end
  end

end
