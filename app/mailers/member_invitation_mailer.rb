class MemberInvitationMailer < ApplicationMailer
  def invitation
    @invitation = params[:invitation]
    @account = @invitation.account
    @invited_by = @invitation.invited_by

    @accept_url =
      member_invitation_url(
        @invitation.token,
        host: "lavkin.kz",
        protocol: "https"
      )

    mail(
      to: @invitation.email,
      subject: "Вас пригласили в #{@account.name} — Lavkin"
    )
  end
end
