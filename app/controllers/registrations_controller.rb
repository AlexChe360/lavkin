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

    @account =
      Account.new
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

  def create_invited_user
    unless @user.email_address.downcase ==
           @invitation.email.downcase

      @user.errors.add(
        :email_address,
        "должен совпадать с email приглашения"
      )

      @account =
        Account.new

      render :new,
             status: :unprocessable_entity

      return
    end

    unless @user.save
      @account =
        Account.new

      render :new,
             status: :unprocessable_entity

      return
    end

    start_new_session_for @user

    token =
      session.delete(
        :pending_invitation_token
      )

    redirect_to member_invitation_path(token),
                notice: "Аккаунт создан. Примите приглашение."
  end

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

    start_new_session_for @user

    redirect_to admin_root_path,
                notice: "Аккаунт успешно создан"

  rescue ActiveRecord::RecordInvalid
    render :new,
           status: :unprocessable_entity
  end

  def set_pending_invitation
    token =
      session[:pending_invitation_token]

      Rails.logger.info(
        ">>> PENDING INVITATION TOKEN: #{token.inspect}"
      )

    return if token.blank?

    @invitation =
      MemberInvitation.find_by(
        token: token
      )

    Rails.logger.info(
      ">>> INVITATION: #{@invitation.inspect}"
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
