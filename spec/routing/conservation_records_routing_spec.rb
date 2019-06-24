# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ConservationRecordsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/conservation_records').to route_to('conservation_records#index')
    end

    it 'routes to #new' do
      expect(get: '/conservation_records/new').to route_to('conservation_records#new')
    end

    it 'routes to #show' do
      expect(get: '/conservation_records/1').to route_to('conservation_records#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/conservation_records/1/edit').to route_to('conservation_records#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/conservation_records').to route_to('conservation_records#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/conservation_records/1').to route_to('conservation_records#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/conservation_records/1').to route_to('conservation_records#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/conservation_records/1').to route_to('conservation_records#destroy', id: '1')
    end
  end
end
