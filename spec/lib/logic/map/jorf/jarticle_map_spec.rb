require 'rails_helper'
require './lib/logic/map/jorf/jarticle_map'

def fake_jarticle_file
  <<-FOO
<ARTICLE>
  <META>
    <META_COMMUN>
      <ID>JORFARTI000030611298</ID>
      <ID_ELI>http://www.legifrance.gouv.fr/eli/arrete/2015/5/7/AFSZ1511210A/jo/article_3</ID_ELI>
      <ANCIEN_ID/>
      <ORIGINE>JORF</ORIGINE>
      <URL>article/JORF/ARTI/00/00/30/61/12/JORFARTI000030611298.xml</URL>
      <NATURE>Article</NATURE>
    </META_COMMUN>
    <META_SPEC>
      <META_ARTICLE>
        <NUM>3</NUM>
        <MCS_ART/>
        <DATE_DEBUT>2999-01-01</DATE_DEBUT>
        <DATE_FIN>2999-01-01</DATE_FIN>
        <TYPE>AU  TONOME</TYPE>
      </META_ARTICLE>
    </META_SPEC>
  </META>
  <CONTEXTE>
    <TEXTE cid="JORFTEXT000030611283" date_publi="2015-05-19" date_signature="2015-05-07" nature="ARRETE" nor="AFSZ1511210A" num="">
      <TITRE_TXT c_titre_court="ARRÊTÉ du 7 mai 2015" debut="2015-05-20" fin="2999-01-01" id_txt="LEGITEXT000030611763">Arrêté du 7 mai 2015 fixant la liste des établissements de santé qui démarrent en facturation individuelle des prestations de soins hospitaliers aux caisses d'assurance maladie obligatoire ainsi que le périmètre de facturation concerné par la facturation individuelle pour chacun de ces établissements de santé</TITRE_TXT>
      <TITRE_TXT c_titre_court="ARRÊTÉ du 7 mai 2015" debut="2999-01-01" fin="2999-01-01" id_txt="JORFTEXT000030611283">Arrêté du 7 mai 2015 fixant la liste des établissements de santé qui démarrent en facturation individuelle des prestations de soins hospitaliers aux caisses d'assurance maladie obligatoire ainsi que le périmètre de facturation concerné par la facturation individuelle pour chacun de ces établissements de santé</TITRE_TXT>
    </TEXTE>
  </CONTEXTE>
  <VERSIONS>
    <VERSION etat="">
      <LIEN_ART debut="2999-01-01" etat="" fin="2999-01-01" id="JORFARTI000030611298" num="3" origine="JORF"/>
    </VERSION>
    <VERSION etat="VIGUEUR">
      <LIEN_ART debut="2015-05-20" etat="VIGUEUR" fin="2999-01-01" id="LEGIARTI000030611789" num="3" origine="LEGI"/>
    </VERSION>
  </VERSIONS>
  <SM>
    <CONTENU/>
  </SM>
  <BLOC_TEXTUEL>
    <CONTENU>
      <p>
        <br/>En application de l'article 4 </p>
      </CONTENU>
    </BLOC_TEXTUEL>
    <LIENS>
    </LIENS>
  </ARTICLE>
  FOO
end

describe 'mapping of jarticle' do

  context "when we have one jarticle" do

    before do
      @xml = fake_jarticle_file
      @jarticle_map = JarticleMap.parse(@xml, :single => true)
    end

    it 'maps correctly the jarticle' do
      expect(@jarticle_map.id_jarticle_origin).to  eq("JORFARTI000030611298")
      expect(@jarticle_map.text).to   eq("\n      \n        En application de l'article 4 \n      ")
      expect(@jarticle_map.number).to  eq(3)
    end

  end
end


