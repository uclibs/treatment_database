# frozen_string_literal: true

class User < ApplicationRecord
  before_save :default_role

  ROLES = %w[admin standard read_only].freeze

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :display_name, presence: true

  def default_role
    self.role ||= 'read_only'
  end
end
