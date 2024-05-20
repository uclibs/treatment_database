require 'rails_helper'

# 4/30 copied directly from ucrate controller spec for our own transition to Shibboleth.
# We will need to modify these tests to fit our own application.
# Callbacks are functions that handle the response from an external service such as Shibboleth.


describe CallbacksController do

  describe 'omniauth-shibboleth' do
    let(:uid) { 'sixplus2@test.com' }
    let(:provider) { :shibboleth }

    before do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      omniauth_hash = { provider: 'shibboleth',
                        uid: uid,
                        extra: {
                          raw_info: {
                            mail: uid,
                            title: 'title',
                            telephoneNumber: '123-456-7890',
                            givenName: 'Fake',
                            sn: 'User',
                            uceduPrimaryAffiliation: 'staff',
                            ou: 'department'
                          }
                        } }
      OmniAuth.config.add_mock(provider, omniauth_hash)
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[provider]
    end

    context 'with a user who is already logged in' do
      let(:user) { FactoryBot.create(:user) }

      before do
        controller.stub(:current_user).and_return(user)
      end
      it 'redirects to the dashboard' do
        get provider
        expect(response).to redirect_to(Hyrax::Engine.routes.url_helpers.dashboard_path)
      end
    end

    shared_examples 'Shibboleth login' do
      it 'assigns the user and redirects' do
        get provider
        expect(flash[:notice]).to match(/You are now signed in as */)
        expect(cookies[:login_type]).not_to eq(nil)
        expect(assigns(:user).email).to eq(email)
        expect(assigns(:user).provider).to eq('shibboleth')
        expect(assigns(:user).uid).to eq(request.env["omniauth.auth"]["uid"])
        expect(assigns(:user).profile_update_not_required).to eq(false)
        expect(response).to be_redirect
      end
    end

      it_behaves_like 'Shibboleth login'

      it 'updates the shibboleth attributes' do
        get provider
        expect(assigns(:user).mail).to eq(request.env["omniauth.auth"]["extra"]["raw_info"]["email"])
      end
    end

    context 'with a registered user who has previously logged in' do
      let!(:user) { FactoryBot.create(:shibboleth_user, count: 1, profile_update_not_required: false) }
      let(:email) { user.email }

      it_behaves_like 'Shibboleth login'
    end

    context 'with a registered user who has never logged in' do
      let!(:user) { FactoryBot.create(:shibboleth_user, count: 0, profile_update_not_required: false) }
      let(:email) { user.email }

      it_behaves_like 'Shibboleth login'

      it 'updates the shibboleth attributes' do
        get provider
         expect(assigns(:user).mail).to eq(request.env["omniauth.auth"]["extra"]["raw_info"]["email"])
      end
    end
end
