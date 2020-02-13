# frozen_string_literal: true

class User < ApplicationRecord
  after_initialize :default_role, :activate_new_account

  ROLES = %w[admin standard read_only].freeze

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :display_name, presence: true

  def default_role
    self.role ||= 'read_only'
  end

  def activate_new_account
    return unless account_active.nil?

    self.account_active = true
  end

  def active_for_authentication?
    # Uncomment the below debug statement to view the properties of the returned self model values.
    # logger.debug self.to_yaml

    super && account_active?
  end
end
