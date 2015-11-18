require 'rails_helper'

RSpec.describe CodesHelper, type: :helper do
  describe "display summary" do

    describe "with no link" do
      before do
        section1_1 =Section.create({title: "1.1"})
        section1 =Section.create({title: "1"})
        section2 =Section.create({title: "2"})

        section1.sections = [section1_1]
        sections=[section1, section2]

        @summary = display_summary(sections, 'accordion')
      end

      it "display one ul li by level" do
        expect(@summary).to eq("<ul id='accordion' class='nav'><li><a href='#'>1</a><ul id='' class='nav'><li><a href='#'>1.1</a></li></ul></li><li><a href='#'>2</a></li></ul>")
      end
    end

    describe "with one link" do
      before do
        section =Section.create({title: "1"})
        article = Article.new(id:3, state: "VIGUEUR")

        section.articles << article

        sections=[section]

        @summary = display_summary(sections)
      end

      it "display one ul li by level with a for link" do
        expect(@summary).to eq("<ul id='' class='nav'><li><a href=\"/sections/1\">1</a></li></ul>")
      end
    end

    describe "with one link" do
      before do
        section =Section.create({title: "1"})
        article = Article.new(id:3, state: "MODIFIE")

        section.articles << article

        sections=[section]

        @summary = display_summary(sections)
      end

      it "display one ul li by level with a for link" do
        expect(@summary).to eq("<ul id='' class='nav'><li><a href='#'>1</a></li></ul>")
      end
    end

  end
end
