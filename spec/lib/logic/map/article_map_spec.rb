require 'rails_helper'
require './lib/logic/extract'
require './lib/logic/map/article_map'

def fake_article_file article, nb_of_versions
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
        <NUM>#{article[:number]}</NUM>
        <ETAT>#{article[:state]}</ETAT>
        <DATE_DEBUT>#{article[:start_date]}</DATE_DEBUT>
        <DATE_FIN>#{article[:end_date]}</DATE_FIN>
        <TYPE>AUTONOME</TYPE>
      </META_ARTICLE>
    </META_SPEC>
</META>
<VERSIONS>"

  nb_of_versions.times do
    body += "<VERSION etat='MODIFIE'>
<LIEN_ART debut='2000-09-21' etat='MODIFIE' fin='2009-11-01' id='#{article[:id_article_origin_version]}' num='L110-1' origine='LEGI'/>
</VERSION>"
  end

body += "</VERSIONS>
<NOTA>
<CONTENU>#{article[:nota_content]}</CONTENU>
</NOTA>
<BLOC_TEXTUEL>
<CONTENU>#{article[:text_content]}</CONTENU>
</BLOC_TEXTUEL>"

  footer = <<-FOO
  </ARTICLE>
  FOO

  header + body + footer
end

describe 'mapping of articles' do

  context "when we have one article without versions" do

    before do
      @xml = fake_article_file({  id_article_origin: "LEGIARTI000006204293",
                                  nota_content: "Décret n° 2006-975 du 1er août 2006 art. 8 :<br/> I.-Les dispositions du présent décret entrent en vigueur le 1er septembre 2006.",
                                  text_content: "I.-Les dispositions du présent code s'appliquent aux marchés publics et aux accords-cadres ainsi définis :<br/>",
                                  number: "L711-23",
                                  nature: "ARTICLE",
                                  start_date: "2015-01-01",
                                  end_date: "2999-01-01",
                                  state: "VIGUEUR",
                                  id_article_origin_version: ""
                               }, 0)

      @articleMap = ArticleMap.parse_with_escape_br(@xml, :single => true)
    end

    it 'maps correctly the article' do
      expect(@articleMap.id_article_origin).to   eq("LEGIARTI000006204293")
      expect(@articleMap.nature).to eq("ARTICLE")
      expect(@articleMap.text).to eq("I.-Les dispositions du présent code s'appliquent aux marchés publics et aux accords-cadres ainsi définis :<br/>")
      expect(@articleMap.nota).to eq("Décret n° 2006-975 du 1er août 2006 art. 8 :<br/> I.-Les dispositions du présent décret entrent en vigueur le 1er septembre 2006.")
      expect(@articleMap.state).to eq("VIGUEUR")
      expect(@articleMap.start_date).to eq("2015-01-01")
      expect(@articleMap.end_date).to eq("2999-01-01")
      expect(@articleMap.number).to eq("L711-23")
      expect(@articleMap.versions.length).to eq(0)
    end

  end

  context "when we have one article with 1 version" do

    before do
      @xml = fake_article_file({  id_article_origin: "LEGIARTI000006204293",
                                  nota_content: "Décret n° 2006-975 du 1er août 2006 art. 8 :<br/> I.-Les dispositions du présent décret entrent en vigueur le 1er septembre 2006.",
                                  text_content: "I.-Les dispositions du présent code s'appliquent aux marchés publics et aux accords-cadres ainsi définis :<br/>",
                                  number: "L711-23",
                                  nature: "ARTICLE",
                                  start_date: "2015-01-01",
                                  end_date: "2015-01-01",
                                  state: "VIGUEUR",
                                  id_article_origin_version: "LEGIARTI000006219125"
                               }, 1)

      @articleMap = ArticleMap.parse_with_escape_br(@xml, :single => true)
    end

    it 'maps correctly the article version' do
      expect(@articleMap.versions.length).to eq(1)
      expect(@articleMap.versions[0].id_article_origin).to eq("LEGIARTI000006219125")
    end

  end

end


