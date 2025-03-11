# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ControlledVocabularies', type: :request do
  let(:read_only_user) { create(:user, role: 'read_only') }
  let(:standard_user) { create(:user, role: 'standard') }
  let(:admin_user) { create(:user, role: 'admin') }
  let(:inactive_user) { create(:user, role: 'standard', account_active: false) }
  let!(:controlled_vocabulary) { create(:controlled_vocabulary) }

  describe 'GET /controlled_vocabularies' do
    context 'when user is read_only' do
      before do
        request_login_as(read_only_user)
      end

      it 'redirects to root path with alert' do
        get controlled_vocabularies_path
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('You are not authorized to access this page.')
      end
    end

    context 'when user is standard' do
      before do
        request_login_as(standard_user)
      end

      it 'redirects to root path with alert' do
        get controlled_vocabularies_path
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('You are not authorized to access this page.')
      end
    end

    context 'when user is admin' do
      before do
        request_login_as(admin_user)
      end

      it 'returns the controlled vocabularies page' do
        get controlled_vocabularies_path
        expect(response).to have_http_status(200)
        expect(response.body).to include('<h1>Controlled Vocabularies</h1>')
        expect(response.body).to include(controlled_vocabulary.vocabulary)
        expect(response.body).to include(controlled_vocabulary.key)
        expect(response.body).to include("href=\"#{new_controlled_vocabulary_path}\">New Controlled Vocabulary</a>")
        expect(response.body).to include("href=\"#{controlled_vocabulary_path(controlled_vocabulary)}\">#{controlled_vocabulary.key}</a>")
      end
    end

    context 'when user is not logged in' do
      it 'redirects to the root path with an error message' do
        get controlled_vocabularies_path
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('You must be signed in to access this page.')
      end
    end

    context 'when user is inactive' do
      before do
        request_login_as(inactive_user, target: controlled_vocabularies_path)
      end

      it 'shows an alert' do
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq('Your account is not active.')
      end
    end
  end

  describe 'GET /controlled_vocabularies/:id' do
    context 'when user is read_only' do
      before do
        request_login_as(read_only_user)
      end

      it 'redirects to root path with alert' do
        get controlled_vocabulary_path(controlled_vocabulary)
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('You are not authorized to access this page.')
      end
    end

    context 'when user is standard' do
      before do
        request_login_as(standard_user)
      end

      it 'redirects to root path with alert' do
        get controlled_vocabulary_path(controlled_vocabulary)
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('You are not authorized to access this page.')
      end
    end

    context 'when user is admin' do
      before do
        request_login_as(admin_user)
      end

      it 'returns the controlled vocabulary page' do
        get controlled_vocabulary_path(controlled_vocabulary)
        expect(response).to have_http_status(200)
        expect(response.body).to include(controlled_vocabulary.key)
        expect(response.body).to include(controlled_vocabulary.vocabulary)
        expect(response.body).to include(controlled_vocabulary.active.to_s)
        expect(response.body).to include(controlled_vocabulary.favorite.to_s)
        expect(response.body).to include('>Edit</a>')
        expect(response.body).to include('Return to List</a>')
      end

      it 'returns a 404 for a non-existent staff_code' do
        get controlled_vocabulary_path(id: 'non-existent-id')
        expect(response).to have_http_status(404)
      end
    end

    context 'when user is not logged in' do
      it 'redirects to the root path with an alert' do
        get controlled_vocabulary_path(controlled_vocabulary)
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('You must be signed in to access this page.')
      end
    end

    context 'when user is inactive' do
      before do
        request_login_as(inactive_user, target: controlled_vocabulary_path(controlled_vocabulary))
      end

      it 'redirects to root path with alert' do
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('Your account is not active.')
      end
    end
  end
end
