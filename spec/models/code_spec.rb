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
        code.save()
        @summary = code.summary
      end

      it "display one section lvl1 and two lvl2" do
        expect(@summary.length).to eq(1)
        expect(@summary[0].section_links.length).to eq(2)
        expect(@summary[0].section_links[0].target.title).to eq("1.1")
        expect(@summary[0].section_links[1].target.title).to eq("1.2")
      end

    end

  end

  describe '.with_vigueur_section_and_articles' do

    context 'when one vigueur section with one article' do
      before do
        article = Article.create()
        section = Section.create(title: 1, state: 'VIGUEUR')
        section.articles << article
        code = Code.create!(escape_title: 'code_civil')
        code.sections << section
        code.save
      end


      xit "should retrieve one section and one article" do
        code = Code.with_displayable_sections_and_articles 'code_civil'
        expect(code.sections.length).to eq(1)
        expect(code.sections[0].articles.length).to eq(1)
      end

    end

    context 'when two sections in vigueur | abroge_diff and one with other state section with no article' do
      before do
        s1 = Section.create(state: 'VIGUEUR')
        s2 = Section.create(state: 'ABROGE_DIFF')
        s3 = Section.create(state: 'other state')
        code = Code.create!(escape_title: 'code_civil')
        code.sections += [s1, s2, s3]
        code.save
      end

      xit "should retrieve two sections" do
        code = Code.with_displayable_sections_and_articles 'code_civil'
        expect(code.sections.length).to eq(2)
      end

    end

  end

end
