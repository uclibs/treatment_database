# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Non-Authenticated User Access', type: :feature do
  let(:record) { FactoryBot.create(:conservation_record) }

  it_behaves_like 'has a non_authenticated user header'

  it 'prevents non-authenticated users from accessing Conservation Records page' do
    prevents_anonymous_access(conservation_records_path)
  end

  it 'prevents non-authenticated users from accessing a specific Conservation Record page' do
    prevents_anonymous_access(conservation_record_path(record.id))
  end

  it 'prevents non-authenticated users from accessing Controlled Vocabularies page' do
    prevents_anonymous_access(controlled_vocabularies_path)
  end

  it 'prevents non-authenticated users from accessing Users page' do
    prevents_anonymous_access(users_path)
  end

  it 'prevents non-authenticated users from accessing Activity page' do
    prevents_anonymous_access('/activity')
  end

  it 'prevents non-authenticated users from accessing Staff Codes page' do
    prevents_anonymous_access(staff_codes_path)
  end

  it 'prevents non-authenticated users from accessing Reports page' do
    prevents_anonymous_access(reports_path)
  end
end
