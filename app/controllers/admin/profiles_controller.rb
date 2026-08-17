module Admin
  class ProfilesController < AdminController
    def show
      @user = Current.user
    end

    def edit
      @user = Current.user
    end

    def update
      @user = Current.user

      if @user.update(profile_params)
        redirect_to admin_profile_path,
                    notice: "Профиль обновлён"
      else
        render :edit,
               status: :unprocessable_entity
      end
    end

    private

    def profile_params
      params
        .require(:user)
        .permit(
          :name,
          :phone
        )
    end
  end
end
