# frozen_string_literal: true
# The read_only_user_context.rb file provides a shared context for
# setting up a read-only user in RSpec tests. This context is essential
# for scenarios where the tests must verify that read-only permissions
# are respected across various parts of the application. For instance,
# it ensures that read-only users cannot create, edit, or delete records
# but can view data as expected. By centralizing the login and setup
# for read-only users here, we ensure that all tests involving these
# users start with a consistent state, improving test reliability and
# reducing redundancy across test suites that need to simulate a
# read-only user environment.
