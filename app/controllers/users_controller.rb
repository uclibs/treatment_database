# frozen_string_literal: true

class UsersController < ApplicationController
  load_and_authorize_resource

  def index
    @users = User.all
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
      flash[:notice] = 'Successfully created User.'
      redirect_to users_path
    else
      flash.now[:notice] = @user.errors.full_messages.first
      redirect_back fallback_location: root_path
    end
  end


  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      flash[:notice] = 'User was successfully updated.'
      redirect_to users_path
    else
      flash.now[:alert] = @user.errors.full_messages.first
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:id, :display_name, :email, :role, :account_active, :password, :password_confirmation)
  end
end
