require 'wombat'


def crawl_section id_section_origin
  Wombat.crawl do
    base_url 'http://www.legifrance.gouv.fr'
    path "/affichCode.do?idSectionTA=#{id_section_origin}&cidTexte=LEGITEXT000006069577"

    articles({css: ".article .titreArt"}, :list) do |a|
      a.each { |article| article.gsub!(' En savoir plus sur cet article...', '') }
    end
  end
end

def articles_displayed_by_us id_section_origin
  section = Section.find_by(id_section_origin: id_section_origin)
  section.section_article_links_valid.includes(:article).map(&:article)
end


namespace :verify do

  desc "extract laws"
  task :code => :environment do
    if ENV['SECTION_IDS'].nil?
      puts 'defined section target by SECTION_IDS=LEGISCTA000006179569 verify:code'
      exit 1
    end

    section_ids = ENV['SECTION_IDS'].split(' ')

    section_ids.each do |section_id|
      puts "for section: #{section_id}"

      legi_articles = (crawl_section section_id)['articles']
      our_articles = (articles_displayed_by_us section_id)

      legi_length = legi_articles.length
      us_length = our_articles.length

      puts "legifrance: #{legi_length} articles"
      puts "us: #{us_length} articles"

      if legi_length == us_length
        puts "Ok"
      else
        puts "Error"
        exit 1
      end

      puts "same title !" if our_articles.map{|a| "#{a.nature} #{a.number}"} == legi_articles

    end
    
  end

end