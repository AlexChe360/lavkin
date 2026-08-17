module Admin
  class MembersController < AdminController
    before_action :require_admin!
    before_action :set_membership,
                  only: %i[
                    edit
                    update
                  ]

    def index
      @memberships =
        Current.account
                .memberships
                .includes(:user)
                .order(created_at: :asc)
    end

    def edit
    end

    def update
      if changing_owner?
        redirect_to admin_members_path,
                    alert: "Роль владельца нельзя изменить здесь"

        return
      end

      if @memberships.update(membership_params)
        redirect_to admin_members_path,
                  notice: "Роль сотрудника обновлена"
      else
        render :edit,
              status: :unprocessable_entity
      end
    end

    private

    def set_membership
      @membership =
        Current.account.memberships.find(params[:id])
    end

    def membership_params
      params
        .require(:membership)
        .permit(:role)
    end

    def changing_owner?
      @memberships.owner? &&
        membership_params[:role] != "owner"
    end
  end
end
