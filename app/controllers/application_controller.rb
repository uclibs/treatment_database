# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pagy::Backend
  before_action :authenticate_user!
  before_action :set_paper_trail_whodunnit

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path , alert: exception.message
  end

  private

  def authenticate_user!
    puts "***********"
    puts "In authenticate_user! method, and user_signed_in? is #{user_signed_in?}"
    puts "***********"
    return if user_signed_in?

    redirect_to root_path, notice: 'You must be logged in to access this page.'
  end

  def user_signed_in?
    puts "&&&&&&&&&&&&&&"
    puts "In user_signed_in, and session[:user_id] is #{session[:user_id]}"
    puts "&&&&&&&&&&&&&&"
    session[:user_id].present?
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if user_signed_in?
  end

  def current_ability
    @current_ability ||= Ability.new(current_user)
  end

  helper_method :current_user, :user_signed_in?
end
