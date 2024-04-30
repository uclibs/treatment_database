# frozen_string_literal: true

# Takes the login logic out of our navigation bar and puts it in a helper method
module NavigationHelper
  def navigation_links(user)
    return 'navigation/logged_out_navigation' if user.blank?

    'navigation/logged_in_navigation'
  end
end
