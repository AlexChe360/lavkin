class MemberInvitationMailer < ApplicationMailer
  def invitation
    @invitation = params[:invitation]

    @account = @invitation.account

    @invited_by = @invitation.invited_by

    @accept_utl = member_invitation_url(@invitation.token)

    mail(to: @invitation.email, subject: "Вас пригласили в #{@account.name} - Lavkin")
  end
end
