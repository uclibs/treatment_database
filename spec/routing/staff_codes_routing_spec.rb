# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StaffCodesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/staff_codes').to route_to('staff_codes#index')
    end

    it 'routes to #new' do
      expect(get: '/staff_codes/new').to route_to('staff_codes#new')
    end

    it 'routes to #show' do
      expect(get: '/staff_codes/1').to route_to('staff_codes#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/staff_codes/1/edit').to route_to('staff_codes#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/staff_codes').to route_to('staff_codes#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/staff_codes/1').to route_to('staff_codes#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/staff_codes/1').to route_to('staff_codes#update', id: '1')
    end
  end
end
