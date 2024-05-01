# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Standard User Functionalities', type: :feature do
  include_context 'standard user context'

  it_behaves_like 'has a standard user header'
  it_behaves_like 'index page access for authenticated users'
  it_behaves_like 'view conservation record details'
  it_behaves_like 'creates new conservation records'
  it_behaves_like 'edits conservation records'
  it_behaves_like 'view staff codes'

  it 'prevents standard users from accessing Controlled Vocabularies page' do
    prevents_unauthorized_access(controlled_vocabularies_path)
  end

  it 'prevents standard users from accessing Users page' do
    prevents_unauthorized_access(users_path)
  end

  it 'prevents standard users from accessing Activity page' do
    prevents_unauthorized_access('/activity')
  end

  it 'prevents standard users from accessing Reports page' do
    prevents_unauthorized_access(reports_path)
  end
end
