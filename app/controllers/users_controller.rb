class UsersController < ApplicationController
  def edit
  end

  def update
    if current_user.update(user_params)
      redirect_to root_path
    else
      render :edit  # 編集に失敗した場合、編集ビューが再描画される。
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email)
    end
end
