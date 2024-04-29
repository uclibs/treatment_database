# frozen_string_literal: true

def flash_alert
  all('.alert-danger').map(&:text).join(' ')
end

def flash_notice
  all('.alert-primary').map(&:text).join(' ')
end
