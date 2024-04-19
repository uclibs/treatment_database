# frozen_string_literal: true
# This file, admin_user_context.rb, defines a shared context for RSpec
# tests that require an admin user to be logged in before the test actions
# can be performed. This context is crucial for tests that involve
# admin-only functionalities, such as managing users or accessing
# administrative dashboards. The context handles the setup and teardown
# processes by logging in an admin user at the beginning of each test and
# ensuring they are logged out at the end if necessary. Usage of this file
# helps avoid duplication of login logic across multiple test files and
# ensures consistency in how admin sessions are handled during tests.
