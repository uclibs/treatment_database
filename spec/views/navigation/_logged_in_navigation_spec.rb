# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'navigation/_logged_in_navigation.html.erb', type: :view do
  let(:user) { create(:user, role: user_role) }

  before do
    view_login_as(user)
    view_stub_authorization(user)
  end

  shared_examples 'common links for logged-in users' do
    it 'displays navigation links common to all users' do
      render partial: 'navigation/logged_in_navigation', locals: { current_user: user }
      expect(rendered).not_to have_link('Sign In')
      expect(rendered).to have_link('Treatment Database', href: root_path)
      expect(rendered).to have_button('Search')

      # Check dropdown button with the user's name
      expect(rendered).to have_button(user.display_name)

      # Check dropdown links
      within('.dropdown-menu') do
        expect(rendered).to have_link('Edit account', href: edit_user_path(user))
        expect(rendered).to have_link('Logout', href: logout_path)
      end
    end
  end

  shared_examples 'log out links visibility' do
    context 'in development environment' do
      it 'displays the Shibboleth logout link' do
        with_environment('development') do
          render partial: 'navigation/logged_in_navigation', locals: { current_user: user }
          within('.dropdown-menu') do
            expect(rendered).to have_link('Log out via Shibboleth', href: shibboleth_logout_path)
          end
        end
      end
    end

    context 'in production environment' do
      it 'does not display the Shibboleth logout link' do
        with_environment('production') do
          render partial: 'navigation/logged_in_navigation', locals: { current_user: user }
          within('.dropdown-menu') do
            expect(rendered).not_to have_link('Log out via Shibboleth', href: shibboleth_logout_path)
          end
        end
      end
    end
  end

  shared_examples 'role-specific links' do
    it 'displays the correct role-specific links' do
      render partial: 'navigation/logged_in_navigation', locals: { current_user: user }
      visible_links.each do |link, path|
        expect(rendered).to have_link(link, href: path)
      end

      hidden_links.each do |link, path|
        expect(rendered).not_to have_link(link, href: path)
      end
    end
  end

  context 'when user is an admin' do
    let(:user_role) { 'admin' }
    let(:visible_links) do
      {
        'Conservation Records' => conservation_records_path,
        'Vocabularies' => controlled_vocabularies_path,
        'Users' => admin_users_path,
        'Activity' => activity_index_path,
        'Reports' => reports_path,
        'Staff Codes' => staff_codes_path
      }
    end
    let(:hidden_links) { {} }
    it_behaves_like 'common links for logged-in users'
    it_behaves_like 'log out links visibility'
    it_behaves_like 'role-specific links'
  end

  context 'when user is a standard user' do
    let(:user_role) { 'standard' }
    let(:visible_links) do
      { 'Conservation Records' => conservation_records_path }
    end
    let(:hidden_links) do
      {
        'Vocabularies' => controlled_vocabularies_path,
        'Users' => admin_users_path,
        'Activity' => activity_index_path,
        'Reports' => reports_path,
        'Staff Codes' => staff_codes_path
      }
    end
    it_behaves_like 'common links for logged-in users'
    it_behaves_like 'log out links visibility'
    it_behaves_like 'role-specific links'
  end

  context 'when user is a read-only user' do
    let(:user_role) { 'read_only' }
    let(:visible_links) do
      { 'Conservation Records' => conservation_records_path }
    end
    let(:hidden_links) do
      {
        'Vocabularies' => controlled_vocabularies_path,
        'Users' => admin_users_path,
        'Activity' => activity_index_path,
        'Reports' => reports_path,
        'Staff Codes' => staff_codes_path
      }
    end
    it_behaves_like 'common links for logged-in users'
    it_behaves_like 'log out links visibility'
    it_behaves_like 'role-specific links'
  end
end
