module Admin
  class AccountPasswordsController < AdminController
    def edit
      @user = Current.user
    end

    def update
      @user = Current.user

      unless @user.authenticate(params[:current_password])
        @user.errors.add(
          :base,
          "Текущий пароль указан неверно"
        )

        render :edit,
               status: :unprocessable_entity

        return
      end

      if @user.update(password_params)
        redirect_to admin_profile_path,
                    notice: "Пароль успешно изменён"
      else
        render :edit,
               status: :unprocessable_entity
      end
    end

    private

    def password_params
      params
        .require(:user)
        .permit(
          :password,
          :password_confirmation
        )
    end
  end
end
