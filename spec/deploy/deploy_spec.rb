# frozen_string_literal: true

require 'rails_helper'

describe 'Deployment tasks' do
  it 'loads the Rails environment for deployment tasks' do
    expect(defined?(Rails)).not_to be_nil
  end

  it 'checks correct environment' do
    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[]).with('RAILS_ENV').and_return('test')
    expect(Rails.env.test?).to be true
  end
end
