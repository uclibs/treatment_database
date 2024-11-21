# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password # This is a Rails macro that adds methods to set and authenticate against a BCrypt password.

  ROLES = %w[admin standard read_only].freeze

  validates :email,
            format: { with: /\A[a-zA-Z0-9._-]+@(ucmail\.uc\.edu|uc\.edu)\z/i, message: 'must be a valid email ending with @ucmail.uc.edu or @uc.edu' },
            presence: true,
            uniqueness: true

  validates :display_name,
            presence: true,
            uniqueness: true,
            length: { maximum: 30 },
            format: { with: /\A[a-zA-Z0-9\s\-._]+\z/, message: 'can only contain letters, numbers, spaces, hyphens, periods, and underscores' }

  validates :username,
            format: { with: /\A[a-zA-Z0-9._-]+\z/, message: 'can only contain letters, numbers, dashes, and underscores' },
            presence: true,
            uniqueness: true

  validates :role,
            presence: true,
            inclusion: { in: ROLES }

  has_paper_trail
end
