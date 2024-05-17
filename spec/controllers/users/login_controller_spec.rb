# This file may be misplaced - we should look at where it's situated.
# Copying over from ucrate's "static_controller_spec.rb" file.
# We dont' currently have a static controller.

#i think we only need this if we want to redirect the user if they are already logged in?

require 'rails_helper'
describe StaticController do
  describe '#login' do
    let(:user) { FactoryBot.create(:user) }

    before do
      controller.stub(:current_user).and_return(user)
    end

    #keep to make sure we want our spec to look for the username on the page...and
    it 'redirects to dashboard when already logged in' do
      get :login
      expect(response).to redirect_to(Hyrax::Engine.routes.url_helpers.dashboard_path)
    end
  end
end