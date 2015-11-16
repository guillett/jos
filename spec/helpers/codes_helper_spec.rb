require 'rails_helper'

RSpec.describe CodesHelper, type: :helper do
  describe "display summary" do

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
end
