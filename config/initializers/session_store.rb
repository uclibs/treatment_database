# frozen_string_literal: true

# Use cookie store for session data
Rails.application.config.session_store :cookie_store, key: '_treatment_database_session',
                                                      secure: Rails.env.production?,
                                                      same_site: :lax,
                                                      expire_after: 14.days
