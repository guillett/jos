require 'rails_helper'

RSpec.describe Code, type: :model do

  describe "summary" do

    def createCodeWithSection options=[{}]
      default = {level: 1, title: "1", id_section_origin: "id1", state: "VIGUEUR", order: 0}
      section_hashs = options.map{|o| default.merge(o)}

      code = Code.new()
      section_hashs.each do |h|
        s=Section.new(h)
        code.sections.push(s)
        code.save()
        code
      end
      code
    end

    describe "with a code with two sections vigueur" do
      before do
        code = createCodeWithSection [{title:"ok"}, {title:"ok2"}]
        @summary = code.summary
      end

      it "displays one section" do
        expect(@summary.length).to eq(2)
        expect(@summary[0].title).to eq("ok")
        expect(@summary[1].title).to eq("ok2")
      end
    end

    describe "with a code with 2 sections of level 1 in descending order" do
      before do
        code = createCodeWithSection [{title:"second", order:2}, {title:"first", order:1}]
        @summary = code.summary
      end

      it "displays two sections in ascending order" do
        expect(@summary[0].title).to eq("first")
        expect(@summary[1].title).to eq("second")
      end
    end



    describe "with a code with 1 section of level 1 and two sections of level 2" do
      before do
        code = createCodeWithSection [
                                         {title:"1", order:1, id_section_origin: '1'},
                                         {title:"1.1", level: 2, order:1, id_section_parent_origin: '1'},
                                         {title:"1.2", level: 2, order:2, id_section_parent_origin: '1'}]
        @summary = code.summary
      end

      it "display one section lvl1 and two lvl2" do
        expect(@summary.length).to eq(1)
        expect(@summary[0].sections.length).to eq(2)
        expect(@summary[0].sections[0].title).to eq("1.1")
        expect(@summary[0].sections[1].title).to eq("1.2")
      end

    end

    describe "with a code with 1 section of level 1 and two sections of level 2  in descending order" do
      before do
        code = createCodeWithSection [
                                         {title:"1", order:1, id_section_origin: '1'},
                                         {title:"1.2", level: 2, order:2, id_section_parent_origin: '1'},
                                         {title:"1.1", level: 2, order:1, id_section_parent_origin: '1'}]
        @summary = code.summary
      end

      it "display one section lvl1 and two lvl2 in order" do
        expect(@summary.length).to eq(1)
        expect(@summary[0].sections.length).to eq(2)
        expect(@summary[0].sections[0].title).to eq("1.1")
        expect(@summary[0].sections[1].title).to eq("1.2")
      end

    end


    describe "with a code with 2 section of level 1 and SAME ID and two sections of level 2" do
      before do
        code = createCodeWithSection [
                                         {title:"1", order:1, id_section_origin: '1'},
                                         {title:"2", order:1, id_section_origin: '1'},
                                         {title:"*.1", level: 2, order:1, id_section_parent_origin: '1'},
                                         {title:"*.2", level: 2, order:2, id_section_parent_origin: '1'}]
        @summary = code.summary
      end

      it "display two sections level2 for each level1" do
        expect(@summary[0].sections.length).to eq(2)
        expect(@summary[1].sections.length).to eq(2)
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

      it "should retrieve one section and one article" do
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

      it "should retrieve two sections" do
        code = Code.with_displayable_sections_and_articles 'code_civil'
        expect(code.sections.length).to eq(2)
      end

    end

  end

end
