class SessionsController < ApplicationController
  layout "authentication"

  allow_unauthenticated_access only: %i[
    new
    create
  ]

  rate_limit(
    to: 10,
    within: 3.minutes,
    only: :create,
    with: -> {
      redirect_to new_session_path,
                  alert: "Слишком много попыток. Попробуйте позже."
    }
  )

  def new
  end

  def create
    user =
      User.authenticate_by(
        params.permit(
          :email_address,
          :password
        )
      )

    unless user
      redirect_to new_session_path,
                  alert: "Неверный email или пароль."

      return
    end

    unless user.email_verified?
      resend_verification_email_if_needed(user)

      redirect_to new_session_path,
                  alert: "Email ещё не подтверждён. Мы отправили письмо с подтверждением."

      return
    end

    start_new_session_for user

    redirect_to after_authentication_url
  end

  def destroy
    terminate_session

    redirect_to new_session_path,
                status: :see_other
  end

  private

  def resend_verification_email_if_needed(user)
    return if user.email_verification_sent_at.present? &&
              user.email_verification_sent_at > 5.minutes.ago

    user.regenerate_email_verification!

    UserMailer
      .with(user: user)
      .email_verification
      .deliver_later
  end
end
