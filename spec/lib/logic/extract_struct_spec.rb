require 'rails_helper'
require './lib/logic/extract'

def fake_struct_file section, nb_of_link
  header = <<-FOO
  <?xml version="1.0" encoding="UTF-8"?>
  <TEXTELR>
  <STRUCT>
  FOO

  body = ""

  nb_of_link.times do
    body += "<LIEN_SECTION_TA cid='LEGISCTA000024561989' debut='#{section[:start_date]}' etat='#{section[:level]}' fin='#{section[:end_date]}' id='#{section[:id_section_origin]}' niv='#{section[:level]}' url='/LEGI/SCTA/00/00/24/56/19/LEGISCTA000024561992.xml'>#{section[:title]}</LIEN_SECTION_TA>"
  end

  footer = <<-FOO
  </STRUCT>
  </TEXTELR>
  FOO
  header + body + footer
end

