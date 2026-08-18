class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch(
    "MAIL_FROM",
    "Lavkin <no-reply@lavkin.kz>"
  )

  layout "mailer"
end
