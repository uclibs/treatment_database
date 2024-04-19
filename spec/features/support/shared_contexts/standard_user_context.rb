# frozen_string_literal: true
# standard_user_context.rb establishes a shared RSpec context used for
# testing functionalities available to standard users. This includes
# actions like creating, viewing, editing, and deleting records, which
# are permitted for standard users but executed under specific constraints
# compared to administrators. The context ensures that a standard user
# is correctly authenticated at the start of each test, providing a
# clean and consistent testing environment. This file is critical for
# validating the application's core functionality from the perspective
# of most end-users, ensuring that standard user privileges and restrictions
# are correctly implemented and maintained.
