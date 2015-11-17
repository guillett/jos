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

        @summary = display_summary(sections)
      end

      it "display one ul li by level" do
        expect(@summary).to eq("<ul><li>1</li><ul><li>1.1</li></ul><li>2</li></ul>")
      end
    end

    describe "with one link" do
      before do
        section =Section.create({title: "1"})
        article = Article.new(id:3)

        section.articles << article

        sections=[section]

        @summary = display_summary(sections)
      end

      it "display one ul li by level with a for link" do
        expect(@summary).to eq("<ul><li><a href=\"/sections/1\">1</a></li></ul>")
      end
    end

  end
end
