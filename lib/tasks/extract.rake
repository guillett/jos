Dir.glob('./lib/logic/**/*.rb').each{|f| require(f) }
require 'pp'

namespace :extract do

  desc "extract laws"
  task :code => :environment do
    puts ENV["TARGET"]
    path = File.absolute_path(ENV["TARGET"])
    extractor = Extractor.new
    codes = extractor.extract_codes_and_sections2(path)

    puts codes.length


    codes.select{|c| !c.nil?}.each { |c| c.save!() }
  end

end