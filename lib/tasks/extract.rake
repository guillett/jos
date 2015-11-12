Dir.glob('./lib/logic/**/*.rb').each{|f| require(f) }
require 'pp'

namespace :extract do

  desc "extract laws"
  task :code => :environment do

    if ENV["TARGET"].nil?
      puts "precise target folder with TARGET='../legi/global/code_et_TNC_en_vigueur/code_en_vigueur'"
      exit 1
    end

    path = File.absolute_path(ENV["TARGET"])
    extractor = Extractor.new
    codes = extractor.extract_codes_and_sections2(path)

    puts "#{codes.length} codes built"


    codes.select{|c| !c.nil?}.each { |c| c.save!() }
  end

end