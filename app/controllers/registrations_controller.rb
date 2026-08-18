class RegistrationsController < ApplicationController
  layout "authentication"

  allow_unauthenticated_access

  before_action :set_pending_invitation
  before_action :redirect_authenticated_user

  def new
    @user =
      if @invitation
        User.new(
          email_address: @invitation.email
        )
      else
        User.new
      end

    @account = Account.new
  end

  def create
    @user =
      User.new(user_params)

    if @invitation
      create_invited_user
    else
      create_owner
    end
  end

  private

  # ------------------------------------------------------------
  # INVITED USER
  # ------------------------------------------------------------

  def create_invited_user
    unless invitation_email_matches?
      @user.errors.add(
        :email_address,
        "должен совпадать с email приглашения"
      )

      @account = Account.new

      render :new,
             status: :unprocessable_entity

      return
    end

    unless @user.save
      @account = Account.new

      render :new,
             status: :unprocessable_entity

      return
    end

    send_verification_email(@user)

    redirect_to new_session_path,
                notice: verification_notice(@user)
  end

  # ------------------------------------------------------------
  # OWNER
  # ------------------------------------------------------------

  def create_owner
    @account =
      Account.new(account_params)

    unless @user.valid? &&
           @account.valid?

      render :new,
             status: :unprocessable_entity

      return
    end

    ActiveRecord::Base.transaction do
      @user.save!
      @account.save!

      Membership.create!(
        user: @user,
        account: @account,
        role: :owner
      )
    end

    # Важно:
    # письмо отправляем уже после завершения транзакции.
    send_verification_email(@user)

    redirect_to new_session_path,
                notice: verification_notice(@user)

  rescue ActiveRecord::RecordInvalid
    render :new,
           status: :unprocessable_entity
  end

  # ------------------------------------------------------------
  # INVITATION
  # ------------------------------------------------------------

  def set_pending_invitation
    token =
      session[:pending_invitation_token]

    return if token.blank?

    @invitation =
      MemberInvitation.find_by(
        token: token
      )

    if @invitation.nil? ||
       @invitation.accepted? ||
       @invitation.expired?

      session.delete(
        :pending_invitation_token
      )

      @invitation = nil
    end
  end

  def invitation_email_matches?
    @user.email_address
         .to_s
         .strip
         .downcase ==
      @invitation.email
                 .to_s
                 .strip
                 .downcase
  end

  # ------------------------------------------------------------
  # EMAIL VERIFICATION
  # ------------------------------------------------------------

  def send_verification_email(user)
    UserMailer
      .with(user: user)
      .email_verification
      .deliver_later
  end

  def verification_notice(user)
    "Аккаунт создан. Мы отправили письмо на #{user.email_address}. Подтвердите email, чтобы войти."
  end

  # ------------------------------------------------------------
  # PARAMS
  # ------------------------------------------------------------

  def user_params
    params
      .require(:user)
      .permit(
        :email_address,
        :password,
        :password_confirmation
      )
  end

  def account_params
    params
      .require(:account)
      .permit(:name)
  end

  # ------------------------------------------------------------
  # AUTHENTICATED USER
  # ------------------------------------------------------------

  def redirect_authenticated_user
    return unless authenticated?

    if session[:pending_invitation_token].present?
      redirect_to member_invitation_path(
        session[:pending_invitation_token]
      )
    else
      redirect_to admin_root_path
    end
  end
end
