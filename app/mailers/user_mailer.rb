class UserMailer < ApplicationMailer
  def email_verification
    @user = params[:user]

    @verification_url =
      email_verification_url(
        @user.email_verification_token,
        host: "lavkin.kz",
        protocol: "https"
      )

    mail(
      to: @user.email_address,
      subject: "Подтвердите email — Lavkin"
    )
  end
end
