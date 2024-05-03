# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Read-Only User Functionalities', type: :feature do
  include_context 'read-only user context'

  it_behaves_like 'index page access for authenticated users'
  it_behaves_like 'view conservation record details'
  it_behaves_like 'has a read_only user header'

  it 'prevents read-only users from accessing New Conservation Records page' do
    prevents_unauthorized_access(new_conservation_record_path)
  end

  it 'prevents read-only users from accessing Edit Conservation Records page' do
    conservation_record = create(:conservation_record)
    prevents_unauthorized_access(edit_conservation_record_path(conservation_record))
  end

  it 'prevents read-only users from accessing Controlled Vocabularies page' do
    prevents_unauthorized_access(controlled_vocabularies_path)
  end

  it 'prevents read-only users from accessing Edit Controlled Vocabulary page' do
    controlled_vocabulary = create(:controlled_vocabulary)
    prevents_unauthorized_access(edit_controlled_vocabulary_path(controlled_vocabulary))
  end

  it 'prevents read-only users from accessing Users page' do
    prevents_unauthorized_access(users_path)
  end

  it 'prevents read-only users from accessing New User page' do
    prevents_unauthorized_access(new_user_path)
  end

  it 'prevents read-only users from accessing Activity page' do
    prevents_unauthorized_access('/activity')
  end

  it 'prevents read-only users from accessing Staff Codes page' do
    prevents_unauthorized_access(staff_codes_path)
  end

  it 'prevents read-only users from accessing New Staff Code page' do
    prevents_unauthorized_access(new_staff_code_path)
  end

  it 'prevents read-only users from accessing Edit Staff Code page' do
    staff_code = create(:staff_code)
    prevents_unauthorized_access(edit_staff_code_path(staff_code))
  end

  it 'prevents read-only users from accessing Reports page' do
    prevents_unauthorized_access(reports_path)
  end
end
