# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'navigation/_logged_in_navigation.html.erb', type: :view do
  before do
    view_login_as(user)
    view_stub_authorization(user)
    render partial: 'navigation/logged_in_navigation', locals: { current_user: user }
  end

  context 'when user is an admin' do
    let(:user) { FactoryBot.create(:user, role: 'admin') }

    it 'displays all admin specific links' do
      expect(rendered).not_to have_link('Log in')
      expect(rendered).to have_link('Treatment Database', href: root_path)
      expect(rendered).to have_link('Conservation Records', href: conservation_records_path)
      expect(rendered).to have_link('Vocabularies', href: controlled_vocabularies_path)
      expect(rendered).to have_link('Users', href: admin_users_path)
      expect(rendered).to have_link('Activity', href: activity_index_path)
      expect(rendered).to have_link('Reports', href: reports_path)
      expect(rendered).to have_link('Staff Codes', href: staff_codes_path)
      expect(rendered).to have_button('Search')
      expect(rendered).to have_link('Edit account', href: edit_user_path(user))
      expect(rendered).to have_link('Logout', href: logout_path)
    end
  end

  context 'when user is a standard user' do
    let(:user) { FactoryBot.create(:user, role: 'standard') }

    it 'displays only standard_user specific links' do
      expect(rendered).not_to have_link('Log in')
      expect(rendered).to have_link('Treatment Database', href: root_path)
      expect(rendered).to have_link('Conservation Records', href: conservation_records_path)
      expect(rendered).not_to have_link('Vocabularies', href: controlled_vocabularies_path)
      expect(rendered).not_to have_link('Users', href: admin_users_path)
      expect(rendered).not_to have_link('Activity', href: activity_index_path)
      expect(rendered).not_to have_link('Reports', href: reports_path)
      expect(rendered).not_to have_link('Staff Codes', href: staff_codes_path)
      expect(rendered).to have_button('Search')
      expect(rendered).to have_link('Edit account', href: edit_user_path(user))
      expect(rendered).to have_link('Logout', href: logout_path)
    end
  end

  context 'when user is a read_only user' do
    let(:user) { FactoryBot.create(:user, role: 'read_only') }

    it 'displays only read_only specific links' do
      expect(rendered).not_to have_link('Log in')
      expect(rendered).to have_link('Treatment Database', href: root_path)
      expect(rendered).to have_link('Conservation Records', href: conservation_records_path)
      expect(rendered).not_to have_link('Vocabularies', href: controlled_vocabularies_path)
      expect(rendered).not_to have_link('Users', href: admin_users_path)
      expect(rendered).not_to have_link('Activity', href: activity_index_path)
      expect(rendered).not_to have_link('Reports', href: reports_path)
      expect(rendered).not_to have_link('Staff Codes', href: staff_codes_path)
      expect(rendered).to have_button('Search')
      expect(rendered).to have_link('Edit account', href: edit_user_path(user))
      expect(rendered).to have_link('Logout', href: logout_path)
    end
  end
end
