# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[create destroy]

  # This user actually exists in our local and test databases, so it should be able to log in until we get Shibboleth
  # connected, at which point he should not be able to log in because he's not in our SSO database.  His
  # display name should be "Chuck Greenman", not "Test User".  This is a placeholder for the Shibboleth
  # attributes as I expect them to be implemented.
  @temp_user_info = { email: 'chuck@chuck.codes', username: 'chuck12', first_name: 'Test', last_name: 'User' } # Placeholder

  def create
    # This will later be replaced with Shibboleth attributes  The commented out lines
    # are placeholders for the Shibboleth attributes as I expect them to be implemented.

    # shobboleth_username = request.env['username']
    # shobboleth_email = request.env['email']

    user = User.find_by(username: @temp_user_info[:username]) || User.find_by(email: @temp_user_info[:email])
    # user = User.find_by(username: shobboleth_username) || User.find_by(email: shobboleth_email)

    if user
      update_user_info(user)
      session[:user_id] = user.id
      redirect_to conservation_records_path, notice: "Welcome, #{user.display_name}. You have successfully logged in."
    else
      redirect_to root_path, notice: 'User not found.  Please contact the system administrator.'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: 'Logged out successfully.'
  end

  private

  def update_user_info(user)
    # The user is allowed to update their display name
    # @user.display_name ||= "#{request.env[:first_name]} #{request.env[:last_name]}"
    user.display_name ||= "#{@temp_user_info[:first_name]} #{@temp_user_info[:last_name]}"

    # Email can change if the user updates their email address with Shibboleth
    # @user.email = request.env[:email]
    user.email = @temp_user_info[:email]
    user.save
  end
end
