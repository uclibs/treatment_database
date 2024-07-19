# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :authenticate_user!, only: [:sign_up_instructions]

  load_and_authorize_resource

  def index
    @users = User.all
  end

  # This is a placeholder action for the user settings page
  def settings
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def create_user
    @user = User.new(user_params)
    if @user.save
      if current_user.present? && current_user.role == 'admin'
        redirect_to users_path
      else
        sign_in(@user)
        redirect_to after_sign_in_path_for(@user)
      end
      flash[:notice] = 'Successfully created User.'
    else
      flash[:notice] = @user.errors.full_messages.first
      redirect_back fallback_location: root_path
    end
  end

  def update
    user = User.find(params[:id])
    user.update!(user_params)
    redirect_to users_path
  end

  private

  def user_params
    params.require(:user).permit(:id, :display_name, :email, :role, :account_active, :password, :password_confirmation)
  end
end
