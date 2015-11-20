require 'rails_helper'
require './lib/logic/extract'
require './lib/logic/map/article_map'

def fake_article_file article, nb_of_link
  header = <<-FOO
  <ARTICLE>
  <META>
  <META_COMMUN>
  FOO

  body = "<ID>#{article[:id_article_origin]}</ID>
<NATURE>#{article[:nature]}</NATURE>
</META_COMMUN>
    <META_SPEC>
      <META_ARTICLE>
        <NUM>L711-23</NUM>
        <ETAT>VIGUEUR</ETAT>
        <DATE_DEBUT>2015-01-01</DATE_DEBUT>
        <DATE_FIN>2999-01-01</DATE_FIN>
        <TYPE>AUTONOME</TYPE>
      </META_ARTICLE>
    </META_SPEC>
</META>
<NOTA>
<CONTENU>#{article[:nota_content]}</CONTENU>
</NOTA>
<BLOC_TEXTUEL>
<CONTENU>#{article[:text_content]}</CONTENU>
</BLOC_TEXTUEL><LIENS>"

  nb_of_link.times do
    body += "<LIEN cidtexte='LEGITEXT000005627819' datesignatexte='2999-01-01' id='#{article[:link_id]}' naturetexte='CODE' nortexte='' num='150' numtexte='' sens='cible' typelien='CITATION'>#{article[:link_title]}</LIEN>"
  end

  footer = <<-FOO
  </LIENS>
  </ARTICLE>
  FOO

  header + body + footer
end

describe 'mapping of articles' do

  describe "when we have one article" do

    before do
      @xml = fake_article_file({  id_article_origin: "LEGIARTI000006204293",
                                  nota_content: "Décret n° 2006-975 du 1er août 2006 art. 8 :<br/> I.-Les dispositions du présent décret entrent en vigueur le 1er septembre 2006.",
                                  text_content: "I.-Les dispositions du présent code s'appliquent aux marchés publics et aux accords-cadres ainsi définis :<br/>",
                                  nature: "ARTICLE",
                                  link_id: "LEGIARTI000017843672",
                                  link_title: "Code des marchés publics - art. 150 (V)"
                               },
                              1)

      @articleMap = ArticleMap.parse_with_escape_br(@xml, :single => true)
    end

    it 'maps correctly the article' do
      expect(@articleMap.id).to   eq("LEGIARTI000006204293")
      expect(@articleMap.nature).to eq("ARTICLE")
      expect(@articleMap.text).to eq("I.-Les dispositions du présent code s'appliquent aux marchés publics et aux accords-cadres ainsi définis :<br/>")
      expect(@articleMap.state).to eq("VIGUEUR")
      expect(@articleMap.start_date).to eq("2015-01-01")
      expect(@articleMap.end_date).to eq("2999-01-01")
      expect(@articleMap.number).to eq("L711-23")
    end

    xit 'maps correctly the article link' do
      articleLinkHash = @articleMap.links.first.to_hash
      expect(articleLinkHash["id_link_origin"]).to  eq("LEGIARTI000017843672")
      expect(articleLinkHash["title"]).to           eq("Code des marchés publics - art. 150 (V)")
    end

  end

end


