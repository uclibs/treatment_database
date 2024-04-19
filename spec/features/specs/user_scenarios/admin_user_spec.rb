# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Admin User Functionalities", type: :feature do
  include_context "admin user context"

  it "passes a test" do
    expect(1).to eq(1)
  end

end