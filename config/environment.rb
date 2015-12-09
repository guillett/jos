# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!


ActionMailer::Base.smtp_settings = {
    :user_name => ENV['MAILGUN_SMTP_LOGIN'],
    :password => ENV['MAILGUN_SMTP_PASSWORD'],
    :domain => ENV['MAILGUN_DOMAIN'],
    :address => 'smtp.mailgun.org',
    :port => 587,
    :authentication => :plain,
    :enable_starttls_auto => true
}
