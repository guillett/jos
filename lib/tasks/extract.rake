require 'net/ftp'

Dir.glob('./lib/logic/**/*.rb').each{|f| require(f) }

namespace :extract do

  desc "extract laws"
  task :code => :environment do

    puts "start extract"

    if ENV["TARGET"].nil?
      puts "define target folder with TARGET='../legi/global/code_et_TNC_en_vigueur/code_en_vigueur' rake extract:code"
      exit 1
    end

    path = File.absolute_path(ENV["TARGET"])
    extractor = Extractor.new
    codes = extractor.extract_codes_and_sections(path)

    puts "#{codes.length} codes built"
  end

  desc "extract jorf"
  task :jorf => :environment do

    puts "start extract"

    if ENV["TARGET"].nil?
      puts "define target folder with TARGET='../jorf/global/' rake extract:jorf"
      exit 1
    end

    path = File.absolute_path(ENV["TARGET"])
    extractor = Extractor.new
    jorf = extractor.extract_jorf(path)

    puts "#{jorf.length} jorfs built"
  end

  desc "Download legi global"
  task :download_global => :environment do
    ftp = Net::FTP.new
    ftp.connect('ftp2.journal-officiel.gouv.fr', 21)
    ftp.login("legi","open1234")
    ftp.passive = true

    filename = 'Freemium_legi_global_20150715.tar.gz'

    filesize = ftp.size(filename)
    transferred = 0
    p "Beginning download of #{filename}, file size: #{filesize}"
    last_output = nil
    ftp.getbinaryfile(filename, "/tmp/#{filename}", 1024) { |data|
      transferred += data.size
      percent_finished = ((transferred).to_f/filesize.to_f)*100
      if percent_finished != last_output
        print "\r"
        print "#{percent_finished.round}% complete"
      else
        print "."
      end
    }
    ftp.close
  end

end