# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationMailer, type: :mailer do
  it 'sets the default from' do
    expect(ApplicationMailer.default[:from]).to eq('from@example.com')
  end

  it 'sets the layout' do
    expect(ApplicationMailer._layout).to eq('mailer')
  end
end
