# frozen_string_literal: true

class UsersController < ApplicationController
  load_and_authorize_resource
  def index
    @users = User.all
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    user = User.find(params[:id])
    user.update!(user_params)
    redirect_to users_path
  end

  private

  def user_params
    params.require(:user).permit(:id, :display_name, :email, :role)
  end
end
