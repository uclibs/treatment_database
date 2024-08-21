# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'navigation/_logged_in_navigation.html.erb', type: :view do
  include Devise::Test::ControllerHelpers

  let(:user) { create(:user, role: user_role) }

  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in user
    render
  end

  shared_examples 'common links for logged-in users' do
    it 'displays common navigation links for all users' do
      expect(rendered).not_to have_link('Log in')
      expect(rendered).to have_link('Treatment Database', href: root_path)
      expect(rendered).to have_button('Search')

      # Check dropdown button with the user's name
      expect(rendered).to have_button(user.display_name)

      # Check dropdown links
      within('.dropdown-menu') do
        expect(rendered).to have_link('Edit account', href: edit_user_path(user))
        expect(rendered).to have_link('Logout', href: destroy_user_session_path, method: :delete)
      end
    end
  end

  context 'when user is an admin' do
    let(:user_role) { 'admin' }

    it_behaves_like 'common links for logged-in users'

    it 'displays all admin-specific links' do
      expect(rendered).to have_link('Conservation Records', href: conservation_records_path)
      expect(rendered).to have_link('Vocabularies', href: controlled_vocabularies_path)
      expect(rendered).to have_link('Users', href: users_path)
      expect(rendered).to have_link('Activity', href: activity_index_path)
      expect(rendered).to have_link('Reports', href: reports_path)
      expect(rendered).to have_link('Staff Codes', href: staff_codes_path)
    end
  end

  context 'when user is a standard user' do
    let(:user_role) { 'standard' }

    it_behaves_like 'common links for logged-in users'

    it 'displays only standard user-specific links' do
      expect(rendered).to have_link('Conservation Records', href: conservation_records_path)
      expect(rendered).not_to have_link('Vocabularies', href: controlled_vocabularies_path)
      expect(rendered).not_to have_link('Users', href: users_path)
      expect(rendered).not_to have_link('Activity', href: activity_index_path)
      expect(rendered).not_to have_link('Reports', href: reports_path)
      expect(rendered).not_to have_link('Staff Codes', href: staff_codes_path)
    end
  end

  context 'when user is a read_only user' do
    let(:user_role) { 'read_only' }

    it_behaves_like 'common links for logged-in users'

    it 'displays only read-only specific links' do
      expect(rendered).to have_link('Conservation Records', href: conservation_records_path)
      expect(rendered).not_to have_link('Vocabularies', href: controlled_vocabularies_path)
      expect(rendered).not_to have_link('Users', href: users_path)
      expect(rendered).not_to have_link('Activity', href: activity_index_path)
      expect(rendered).not_to have_link('Reports', href: reports_path)
      expect(rendered).not_to have_link('Staff Codes', href: staff_codes_path)
    end
  end
end
