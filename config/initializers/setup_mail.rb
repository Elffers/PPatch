
ActionMailer::Base.smtp_settings = {
  :address              => "smtp.mandrillapp.com",
  :port                 => 587,
  :domain               => "thewormhole.herokuapp.com",
  :user_name            => "admin@wormhole.com",
  :password             => ENV['MANDRILL_KEY'],
  :authentication       => "login",
  :enable_starttls_auto => true
}

ActionMailer::Base.default_url_options[:host] = "thewormhole.herokuapp.com"
# Mail.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?