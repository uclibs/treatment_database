# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  # # include SamlHelper
  #
  # let(:user) { create(:user) }
  # let(:another_user) { create(:user) }
  # let(:inactive_user) { create(:user, account_active: false) }
  #
  # let(:shib_attributes) do
  #   {
  #     'Shib-Attributes' => {
  #       uid: user.username,
  #       givenName: 'TestFirstName',
  #       sn: 'TestLastName'
  #     }
  #   }
  # end
  #
  # let(:inactive_shib_attributes) do
  #   {
  #     'Shib-Attributes' => {
  #       uid: inactive_user.username,
  #       givenNae: 'InactiveFirstName',
  #       sn: 'InactiveLastName'
  #     }
  #   }
  # end
  #
  # let(:shib_attributes_invalid_user) do
  #   {
  #     'Shib-Attributes' => {
  #       uid: 'nonexistent_user',
  #       givenName: 'TestFirstName',
  #       sn: 'TestLastName'
  #     }
  #   }
  # end
  #
  # let(:shib_attributes_missing_username) do
  #   {
  #     'Shib-Attributes' => {
  #       givenName: 'TestFirstName',
  #       sn: 'TestLastName'
  #     }
  #   }
  # end
  #
  # describe 'GET #new' do
  # end
  #
  # describe 'DELETE #destroy' do
  #   context 'when the user is active' do
  #     before do
  #       controller_login_as(user)
  #       session[:user_id] = user.id
  #     end
  #
  #     it 'logs out the user, resets session, clears cookies, and redirects to the root page' do
  #       with_environment('production') do
  #         ENV['SHIBBOLETH_LOGOUT_URL'] = 'http://test.host/logout'
  #
  #         allow(controller).to receive(:root_url).and_return('http://test.host/')
  #
  #         expect(session[:user_id]).to eq(user.id)
  #
  #         delete :destroy
  #
  #         expect(session[:user_id]).to be_nil
  #         expect(cookies.to_hash).to be_empty
  #
  #         expected_redirect_url = "http://test.host/logout?target=#{CGI.escape('http://test.host/')}"
  #
  #         expect(response).to redirect_to(expected_redirect_url)
  #         expect(flash[:notice]).to eq('Signed out successfully')
  #       end
  #     end
  #   end
  #
  #   context 'when the user is inactive' do
  #     before do
  #       controller_login_as(inactive_user)
  #       session[:user_id] = inactive_user.id
  #     end
  #
  #     it 'logs out the user and redirects to Shibboleth logout URL' do
  #       ENV['SHIBBOLETH_LOGOUT_URL'] = 'http://test.host/logout'
  #       allow(controller).to receive(:root_url).and_return('http://test.host/')
  #
  #       delete :destroy
  #
  #       expected_redirect_url = "http://test.host/logout?target=#{CGI.escape('http://test.host/')}"
  #
  #       expect(session[:user_id]).to be_nil
  #       expect(response).to redirect_to(expected_redirect_url)
  #     end
  #   end
  # end
  #
end
