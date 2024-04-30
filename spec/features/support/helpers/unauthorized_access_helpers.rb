# frozen_string_literal: true

require 'rails_helper'

module AuthenticationHelpers
  def prevents_anonymous_access(path)
    visit path
    check_unauthenticated_access
  end

  def prevents_unauthorized_access(path)
    verify_no_link_present(path)
    verify_no_active_button(path)
    visit path
    check_unauthorized_access
  end

  private

  def check_unauthenticated_access
    expect(flash_alert).to have_content('You need to sign in or sign up before continuing.')
    expect(page).to have_current_path(new_user_session_path)
    expect(page).to have_content('Log in')
  end

  def check_unauthorized_access
    expect(flash_notice).to have_content('You are not authorized to access this page.')
    expect(page).to have_current_path(root_path)
    expect(page).to_not have_content('Log in')
  end

  def verify_no_link_present(path)
    # The link shouldn't be available in the user's view.
    expect(page).to have_no_link(nil, href: path)
  end

  def verify_no_active_button(path)
    # Some pages for read-only view have disabled buttons that are present but not active.
    expect(page).to have_no_selector(:css, "button[href='#{path}']:not([disabled])")
  end
end
