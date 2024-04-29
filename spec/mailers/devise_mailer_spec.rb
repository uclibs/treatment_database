# frozen_string_literal: true

require "rails_helper"

RSpec.describe Devise::Mailer, type: :mailer do
  # This test verifies that the Devise mailer, which inherits from our ApplicationMailer,
  # is able to send emails correctly. By testing the Devise mailer, we indirectly test
  # our ApplicationMailer, ensuring that it is properly set up for sending emails.
  describe '#reset_password_instructions' do
    let(:user) { create(:user) }
    let(:mail) { described_class.reset_password_instructions(user, user.reset_password_token) }

    it 'renders the subject' do
      expect(mail.subject).to eq('Reset password instructions')
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([user.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'includes link to reset password' do
      expect(mail.body.encoded)
        .to match(/http:\/\/localhost:3000\/users\/password\/edit/)
    end
  end
end
