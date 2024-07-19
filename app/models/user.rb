# frozen_string_literal: true

class User < ApplicationRecord
  ROLES = %w[admin standard read_only].freeze

  after_initialize :default_role, :activate_new_account
  before_validation :set_default_username, on: :create

  has_paper_trail

  validates :display_name, :email, :role, presence: true
  validates :email, uniqueness: true
  validates :username, presence: true, uniqueness: true

  def active_for_authentication?
    account_active?
  end

  private

  def default_role
    self.role ||= 'read_only'
  end

  def activate_new_account
    self.account_active = true if account_active.nil?
  end

  def set_default_username
    self.username ||= email.split('@').first if email.present?
  end
end
