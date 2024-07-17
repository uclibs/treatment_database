# frozen_string_literal: true
class CallbacksController < Devise::OmniauthCallbacksController
  # def orcid
  #   omni = request.env["omniauth.auth"]
  #   Devise::MultiAuth.capture_successful_external_authentication(current_user, omni)
  #   redirect_to root_path, notice: "You have successfully connected with your ORCID record"
  # end

  def shibboleth
    if current_user
      unless @user.has_logged_in_with_sso?
        @user.update(has_logged_in_with_sso: true)
        redirect_to user_settings_path(first_sign_in: true) and return
      end
      redirect_to root_path
    else
      retrieve_shibboleth_attributes
      sign_in_shibboleth_user
      update_user_shibboleth_attributes
    end
  end

  private

  def retrieve_shibboleth_attributes
    @omni = request.env["omniauth.auth"]
    @email = use_uid_if_email_is_blank
  end

  def update_shibboleth_user
    # update_user_shibboleth_attributes if user_has_never_logged_in?
    # update_user_shibboleth_perishable_attributes
  end

  def sign_in_shibboleth_user
    sign_in_and_redirect @user, event: :authentication # this will throw if @user is not activated
    cookies[:login_type] = {
      value: "shibboleth",
      secure: Rails.env.production?
    }
    flash[:notice] = "You are now signed in as #{@user.name} (#{@user.email})"
  end

  def use_uid_if_email_is_blank
    # If user has no email address use their sixplus2@uc.edu instead
    # Some test accounts on QA/dev don't have email addresses
    return @omni.extra.raw_info.mail if defined?(@omni.extra.raw_info.mail) && @omni.extra.raw_info.mail.present?
    @omni.uid
  end

  def user_exists?
    @user = User.where(provider: @omni['provider'], uid: @omni['uid']).first
  end

  # def user_has_never_logged_in?
    # @user.sign_in_count.zero?
  # end

  def create_user
    @user = User.create provider: @omni.provider,
                        uid: @omni.uid,
                        email: @email,
                        password: Devise.friendly_token[0, 20],
                        profile_update_not_required: false
  end

  def update_user_shibboleth_attributes
    # @user.title              = @omni.extra.raw_info.title
    # @user.telephone          = @omni.extra.raw_info.telephoneNumber
    @user.first_name         = @omni.extra.raw_info.givenName
    @user.last_name          = @omni.extra.raw_info.sn
    @user.email              = @omni.extra.raw_info.mail
    @user.save
  end

  def update_user_shibboleth_perishable_attributes
    # @user.uc_affiliation     = @omni.extra.raw_info.uceduPrimaryAffiliation
    # @user.ucdepartment       = @omni.extra.raw_info.ou
    # @user.save
  end

  def send_welcome_email
    WelcomeMailer.welcome_email(@user).deliver
  end
end