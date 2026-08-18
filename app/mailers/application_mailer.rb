class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch(
    "MAIL_FROM",
    "Lavkin <info@lavkin.kz>"
  )

  layout "mailer"
end
