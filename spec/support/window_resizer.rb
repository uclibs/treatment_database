# frozen_string_literal: true

module WindowResizer
  def resize_window_to(width, height)
    page.driver.browser.manage.window.resize_to(width, height)
  end

  def set_default_window_size
    resize_window_to(1280, 1024) # Default desktop size
  end

  def set_tablet_window_size
    resize_window_to(768, 1024) # Typical tablet size
  end

  def set_mobile_window_size
    resize_window_to(375, 667) # Typical mobile size
  end
end
