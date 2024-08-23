# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ControlledVocabulariesController, type: :controller do
  render_views

  let(:valid_attributes) do
    { vocabulary: 'repair_type', key: 'Wash', active: true, favorite: true }
  end

  let(:invalid_attributes) do
    { vocabulary: '', key: '', active: true }
  end

  let(:user) { create(:user, role: 'admin') }

  before do
    controller_login_as(user)
    controller_stub_authorization(user)
  end

  describe 'GET #index' do
    it 'returns a success response' do
      ControlledVocabulary.create! valid_attributes
      get :index, params: {}
      expect(response).to be_successful
    end

    it 'has the correct content' do
      ControlledVocabulary.create! valid_attributes
      get :index, params: {}
      expect(response.body).to have_content('Controlled Vocabularies')
      expect(response.body).to have_content('repair_type')
      expect(response.body).to have_content('Wash')
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      controlled_vocabulary = ControlledVocabulary.create! valid_attributes
      get :show, params: { id: controlled_vocabulary.to_param }
      expect(response).to be_successful
      expect(response.body).to have_content('repair_type')
      expect(response.body).to have_content('Wash')
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get :new, params: {}
      expect(response).to be_successful
    end
  end

  describe 'GET #edit' do
    it 'returns a success response' do
      controlled_vocabulary = ControlledVocabulary.create! valid_attributes
      get :edit, params: { id: controlled_vocabulary.to_param }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new ControlledVocabulary' do
        expect do
          post :create, params: { controlled_vocabulary: valid_attributes }
        end.to change(ControlledVocabulary, :count).by(1)
      end

      it 'redirects to the created controlled_vocabulary' do
        post :create, params: { controlled_vocabulary: valid_attributes }
        expect(response).to redirect_to(ControlledVocabulary.last)
      end
    end

    context 'with invalid params' do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: { controlled_vocabulary: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        { vocabulary: 'something', key: 'else', active: false, favorite: true }
      end

      it 'updates the requested controlled_vocabulary' do
        controlled_vocabulary = ControlledVocabulary.create! valid_attributes
        put :update, params: { id: controlled_vocabulary.to_param, controlled_vocabulary: new_attributes }
        controlled_vocabulary.reload
        expect(controlled_vocabulary.vocabulary).to eq('something')
        expect(controlled_vocabulary.key).to eq('else')
        expect(controlled_vocabulary.active).to eq(false)
        expect(controlled_vocabulary.favorite).to eq(true)
      end

      it 'redirects to the controlled_vocabulary' do
        controlled_vocabulary = ControlledVocabulary.create! valid_attributes
        put :update, params: { id: controlled_vocabulary.to_param, controlled_vocabulary: valid_attributes }
        expect(flash[:notice]).to eq('Controlled vocabulary was successfully updated.')
        expect(response).to redirect_to(controlled_vocabulary)
      end
    end

    context 'with invalid params' do
      it "returns a success response (i.e. to display the 'edit' template)" do
        controlled_vocabulary = ControlledVocabulary.create! valid_attributes
        put :update, params: { id: controlled_vocabulary.to_param, controlled_vocabulary: invalid_attributes }
        expect(response).to be_successful
        expect(response).to render_template(:edit)
        expect(response.body).to have_content("Vocabulary can't be blank")
        expect(response.body).to have_content("Key can't be blank")
      end
    end
  end
end
