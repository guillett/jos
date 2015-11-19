class SectionsController < ApplicationController
  def show
    @section = Section.find(params[:id])

    code_sections = Code.includes(sections: :articles).where(sections: { state: 'VIGUEUR' }).find(@section.code.id)
    @sub_sections = code_sections.summary_start_id(@section.id).first.sections
  end
end
  