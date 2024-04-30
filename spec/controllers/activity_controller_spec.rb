# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ActivityController, type: :controller do
  render_views

  before do
    user = create(:user, role: 'admin')
    controller_login_as(user)
  end

  let(:valid_attributes) do
    {
      item_type: 'ConservationRecord',
      item_id: 5,
      event: 'create',
      whodunnit: 1,
      created_at: Date.new
    }
  end

  describe 'GET #index' do
    it 'returns a success response' do
      PaperTrail::Version.create! valid_attributes
      get :index, params: {}
      expect(response).to be_successful
    end

    it 'has the appropriate content' do
      PaperTrail::Version.create! valid_attributes
      get :index, params: {}
      expect(response.body).to have_content('Recent Activity')
      expect(response.body).to have_content('created the conservation record')
    end
  end

  describe 'GET #show' do
    let(:conservation_record) { create(:conservation_record) }

    it 'returns a success response' do
      version = PaperTrail::Version.create! valid_attributes
      get :show, params: { id: version.to_param }
      expect(response).to be_successful
    end

    it 'returns change details', versioning: true do
      conservation_record.update(title: 'The Oddysee')
      changes = conservation_record.versions.last.changeset.reject { |k, _v| (k.to_sym == :updated_at) }
      expect(changes).to(eq('title' => ['The Illiad', 'The Oddysee']))
    end
  end
end
