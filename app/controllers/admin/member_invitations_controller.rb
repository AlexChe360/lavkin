module Admin
  class MemberInvitationsController < AdminController
    before_action :require_admin!

    def new
      @invitation =
        Current.account.member_invitations.new
    end

    def create
      email = invitation_params[:email].to_s.strip.downcase

      if Current.account.users.where("LOWER(email_address) = ?", email).exists?
        @invitation = Current.account.member_invitations.new(invitation_params)

        @invitation.errors.add(:email, "уже принадлежит сотруднику этого бизнеса")

        render :new, status: :unprocessable_entity

      end

      @invitation = Current.account.member_invitations.new(invitation_params)
      @invitation.invited_by = Current.user

      if @invitation.save
        redirect_to admin_members_path,
                    notice: "Приглашение создано"
      else
        render :new,
              status: :unprocessable_entity
      end
    end

    private

    def invitation_params
      params
        .require(:member_invitation)
        .permit(:email, :role)
    end
  end
end
