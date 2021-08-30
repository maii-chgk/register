# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!

ActionMailer::Base.smtp_settings = {
  :user_name => 'postmaster@sandboxe95e0bd0780c44e0804a94e94ecad114.mailgun.org',
  :password => Rails.application.credentials.mailgun[:password],
  :domain => 'sandboxe95e0bd0780c44e0804a94e94ecad114.mailgun.org',
  :address => 'smtp.mailgun.org',
  :port => 587,
  :authentication => :plain,
  :enable_starttls_auto => true
}