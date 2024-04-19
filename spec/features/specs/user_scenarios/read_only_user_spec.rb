# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Read-Only User Functionalities", type: :feature do
  include_context "read-only user context"

  it "passes a test" do
    expect(1).to eq(1)
  end

end