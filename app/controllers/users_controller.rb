# frozen_string_literal: true

# Manages user profile actions, allowing users to view and update their own profile.
class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user
  skip_before_action :check_user_active, only: %i[show edit update]

  load_and_authorize_resource

  def show; end

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to root_path, notice: 'Profile updated successfully.'
    else
      render :edit
    end
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:display_name)
  end
end
