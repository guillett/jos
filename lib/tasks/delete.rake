Dir.glob('./lib/logic/**/*.rb').each{|f| require(f) }

namespace :delete do

  desc "truncate code model"
  task :code => :environment do

    Code.destroy_all
    puts "#{Code.all.length} code in database"
  end

end