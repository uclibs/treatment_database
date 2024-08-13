# frozen_string_literal: true

# This helper provides a method to resize the browser window in system tests.
module SystemTestHelper
  def resize_window_to(width, height)
    page.driver.browser.manage.window.resize_to(width, height)
  end
end
