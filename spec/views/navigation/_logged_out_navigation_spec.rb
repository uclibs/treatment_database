# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'navigation/_logged_out_navigation.html.erb', type: :view do
  context 'when no user is logged in' do
    before do
      view_logout
      render partial: 'navigation/logged_out_navigation'
    end

    it 'displays login link and hides user-specific links' do
      expect(rendered).to have_link('Login')
      expect(rendered).to have_link('Treatment Database', href: root_path)
      expect(rendered).not_to have_link('Conservation Records', href: conservation_records_path)
      expect(rendered).not_to have_link('Vocabularies', href: controlled_vocabularies_path)
      expect(rendered).not_to have_link('Users', href: admin_users_path)
      expect(rendered).not_to have_link('Activity', href: activity_index_path)
      expect(rendered).not_to have_link('Reports', href: reports_path)
      expect(rendered).not_to have_link('Staff Codes', href: staff_codes_path)
      expect(rendered).not_to have_button('Search')
      expect(rendered).not_to have_link('Edit account')
      expect(rendered).not_to have_link('Logout', href: logout_path)
    end
  end
end