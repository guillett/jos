require 'rails_helper'

RSpec.describe Code, type: :model do

  describe "summary" do

    describe "with a code with one section" do
      before do
        code = Code.new()
        @section_1 = Section.new({level: 1, title: "1", id_section_origin: "id"})
        code.sections.push(@section_1)
        code.save()
        @summary = code.summary
      end

      it "displays one section" do
        expect(@summary).to eq([@section_1])
      end
    end

    describe "with a code with 2 sections of level 1" do
      before do
        code = Code.new()
        @section_1 = Section.new({level: 1, title: "1", id_section_origin: "id1"})
        @section_2 = Section.new({level: 1, title: "2", id_section_origin: "id2"})
        code.sections.push(@section_1)
        code.sections.push(@section_2)
        code.save()
        @summary = code.summary
      end

      it "displays two sections" do
        expect(@summary).to eq([@section_1, @section_2])
      end
    end

    describe "with a code with 1 sections of level 1 and one section of level 2" do
      before do
        code = Code.new()
        @section_1 = Section.new({level: 1, title: "1", id_section_origin: "1"})
        @section_1_1 = Section.new({level: 2, title: "1.1", id_section_origin: "1.1", id_section_parent_origin: "1"})
        code.sections.push(@section_1)
        code.sections.push(@section_1_1)
        code.save()
        @summary = code.summary
      end

      it "display one section" do
        expect(@summary).to eq([@section_1])
        expect(@summary[0].sections[0]).to eq(@section_1_1)
      end

    end

    describe "with a code with 1 sections of level 2 and one section of level 2" do
      before do
        code = Code.new()
        @section_1 = Section.new({level: 1, title: "1", id_section_origin: "1"})
        @section_1_1 = Section.new({level: 2, title: "1.1", id_section_origin: "1.1", id_section_parent_origin: "1"})
        @section_1_2 = Section.new({level: 2, title: "1.2", id_section_origin: "1.2", id_section_parent_origin: "1"})
        code.sections.push(@section_1)
        code.sections.push(@section_1_1)
        code.sections.push(@section_1_2)
        code.save()
        @summary = code.summary
      end

      it "display one section" do
        expect(@summary).to eq([@section_1])
        expect(@summary[0].sections.length).to eq(2)
        expect(@summary[0].sections[1]).to eq(@section_1_2)
      end
    end

  end

end
