# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin User Functionalities', type: :feature do
  include_context 'admin user context'

  it_behaves_like 'has an admin user header'
  it_behaves_like 'index page access for authenticated users'
  it_behaves_like 'view conservation record details'
  it_behaves_like 'creates new conservation records'
  it_behaves_like 'edits conservation records'
  it_behaves_like 'creates new in-house repairs'
  it_behaves_like 'view controlled vocabularies'
  it_behaves_like 'creates new controlled vocabularies'
  it_behaves_like 'edits controlled vocabularies'
  it_behaves_like 'view user management'
  it_behaves_like 'creates new users'
  it_behaves_like 'edits users'
  it_behaves_like 'view activity'
  it_behaves_like 'view staff codes'
  it_behaves_like 'creates new staff codes'
  it_behaves_like 'edits staff codes'
  it_behaves_like 'view reports'
end
