# frozen_string_literal: true

module Admin
  class UsersController < ApplicationController
    before_action :authorize_admin
    before_action :authenticate_user!
    before_action :set_user, only: %i[show edit update destroy]

    def index
      @users = User.all
    end

    def show; end

    def new
      @user = User.new
    end

    def edit; end

    def create
      @user = User.new(user_params)
      assign_username

      if @user.save
        redirect_to admin_users_path, notice: 'User created successfully.'
      else
        flash.now[:alert] = 'There was a problem creating the user. Please check the errors below.'
        render :new
      end
    end

    def update
      if @user.update(user_params)
        redirect_to admin_users_path, notice: 'Profile updated successfully.'
      else
        render :edit
      end
    end

    def destroy
      redirect_to admin_users_path, alert: 'User deletion is not permitted.'
    end

    private

    def assign_username
      @user.username ||= @user.email.split('@').first if @user.email.present?
    end

    def set_user
      @user = User.find(params[:id])
    end

    def authorize_admin
      redirect_to root_path, alert: 'Access denied.' unless admin?
    end

    def user_params
      permitted_attributes = %i[email password password_confirmation display_name]
      permitted_attributes += %i[role account_active] if admin?
      params.require(:user).permit(permitted_attributes)
    end
  end
end
