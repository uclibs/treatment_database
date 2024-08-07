# frozen_string_literal: true

require 'rails_helper'

describe 'Deployment tasks' do
  it 'loads the Rails environment for deployment tasks' do
    expect(defined?(Rails)).not_to be_nil
  end

  it 'uses the test environment' do
    expect(Rails.env.test?).to be true
  end
end
