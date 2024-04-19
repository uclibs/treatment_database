# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Standard User Functionalities", type: :feature do
  include_context "standard user context"

  it "passes a test" do
    expect(1).to eq(1)
  end

end