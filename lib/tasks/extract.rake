require 'net/ftp'
require 'rubygems/package'
require 'zlib'

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
    extractor.extract_jorf(path)
  end

  desc "extract jorf2"
  task :jorf2 => :environment do

    puts "start extract"

    if ENV["TARGET"].nil?
      puts "define target folder with TARGET='../jorf/global/' rake extract:jorf2"
      exit 1
    end

    path = File.absolute_path(ENV["TARGET"])
    extractor = Extractor.new
    extractor.extract_jorf2(path)
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

  desc "Download and extract daily jorf"
  task :download_and_extract_daily_jorf => :environment do
    ftp = Net::FTP.new
    ftp.connect('ftp2.journal-officiel.gouv.fr', 21)
    ftp.login("jorf","open1234")
    ftp.passive = true

    currentDate = Time.new.strftime("%Y%m%d")
    start_filename = 'jorf_' + currentDate
    remote_filenames = ftp.nlst

    filenames = remote_filenames.select{|fn| fn.start_with?(start_filename)}.sort.each do |filename|

      #download
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
          print "\r"
        else
          print "."
        end
      }

      #unzip
      p "Decompressing of #{filename}"
      `tar zxf /tmp/#{filename} -C /tmp/`

      #extract
      filename_extract = filename.split(".").first.split("_").last
      p "Beginning extraction of #{filename_extract}"
      extractor = Extractor.new(true)
      extractor.extract_jorf("/tmp/#{filename_extract}/jorf/global")

    end

    ftp.close
  end

end