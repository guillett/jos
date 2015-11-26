namespace :cloudfront do
  
  desc 'invalidate all cache'
  task invalidate_all: :environment do
    cloudfront = Aws::CloudFront::Client.new(region: 'eu-central-1')
    resp = cloudfront.create_invalidation({distribution_id: 'E1QAH5UPK80B7R', invalidation_batch: { paths: {quantity: 1, items:['/*']}, caller_reference: "from rake #{Time.now}" } })
    raise "Error while invalidating cache : \n#{resp.inspect}" unless resp.invalidation.status == 'InProgress'
  end

  desc 'warmup all cloudfront cache'
  task warmup: :environment do
    Anemone.crawl("http://www.jo-nf.fr/codes") do |anemone|
      anemone.on_every_page do |page|
        puts page.url
      end
    end
  end

end