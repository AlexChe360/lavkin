class EmailVerificationsController < ApplicationController
  allow_unauthenticated_access

  layout "authentication"

  def pending
    @email =
      session[:pending_verification_email]
  end

  def show
    user =
      User.find_by(
        email_verification_token: params[:token]
      )

    unless user
      redirect_to new_session_path,
                  alert: "Ссылка подтверждения недействительна."

      return
    end

    if user.email_verification_expired?
      session[:pending_verification_email] =
        user.email_address

      redirect_to email_verification_pending_path,
                  alert: "Срок действия ссылки истёк. Отправьте письмо повторно."

      return
    end

    user.verify_email!

    session.delete(
      :pending_verification_email
    )

    redirect_to new_session_path,
                notice: "Email подтверждён. Теперь вы можете войти."
  end

  def resend
    email =
      session[:pending_verification_email]
        .to_s
        .strip
        .downcase

    user =
      User.find_by(
        email_address: email
      )

    unless user
      redirect_to email_verification_pending_path,
                  alert: "Не удалось найти пользователя."

      return
    end

    if user.email_verified?
      redirect_to new_session_path,
                  notice: "Email уже подтверждён."

      return
    end

    if user.email_verification_sent_at.present? &&
       user.email_verification_sent_at > 2.minutes.ago

      redirect_to email_verification_pending_path,
                  alert: "Письмо уже отправлено. Попробуйте повторно немного позже."

      return
    end

    user.regenerate_email_verification!

    UserMailer
      .with(user: user)
      .email_verification
      .deliver_later

    redirect_to email_verification_pending_path,
                notice: "Письмо отправлено повторно."
  end
end
