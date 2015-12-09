namespace :mail do

  desc "extract laws"
  task :last_container => :environment do
    Extractor.new.mail_about_last_container
  end

end