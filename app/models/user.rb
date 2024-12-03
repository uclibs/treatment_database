# frozen_string_literal: true

class User < ApplicationRecord
  ROLES = %w[admin standard read_only].freeze

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
