class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch("DEFAULT_FROM_EMAIL", "no-reply@5000.dev")
  layout "mailer"
end
