class MemberInvitationsController < ApplicationController
  allow_unauthenticated_access

  layout "public"

  before_action :set_invitation

  def show
    if @invitation.accepted?
      redirect_to root_path,
                  alert: "Это приглашение уже использовано"

      return
    end

    if @invitation.expired?
      redirect_to root_path,
                  alert: "Срок действия приглашения истёк"

      nil
    end
  end

  def accept
    unless authenticated?
      session[:pending_invitation_token] =
        @invitation.token

      redirect_to new_session_path,
                  alert: "Войдите или зарегистрируйтесь, чтобы принять приглашение"

      return
    end

    if @invitation.accepted?
      redirect_to root_path,
                  alert: "Это приглашение уже использовано"

      return
    end

    if @invitation.expired?
      redirect_to root_path,
                  alert: "Срок действия приглашения истёк"

      return
    end

    unless Current.user.email_address.downcase ==
           @invitation.email.downcase

      redirect_to member_invitation_path(
                    @invitation.token
                  ),
                  alert: "Приглашение предназначено для другого email"

      return
    end

    Membership.transaction do
      membership =
        Membership.find_or_initialize_by(
          user: Current.user,
          account: @invitation.account
        )

      membership.role =
        @invitation.role

      membership.save!

      @invitation.update!(
        accepted_at: Time.current
      )
    end

    redirect_to admin_root_path,
                notice: "Приглашение принято"

  rescue ActiveRecord::RecordInvalid => error
    redirect_to member_invitation_path(
                  @invitation.token
                ),
                alert: error.message
  end

  private

  def set_invitation
    @invitation =
      MemberInvitation.find_by!(
        token: params[:token]
      )
  end
end
