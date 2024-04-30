# frozen_string_literal: true

require 'rails_helper'
require 'nokogiri'

RSpec.describe 'StaffCodes', type: :request do
  let(:read_only_user) { create(:user, role: 'read_only') }
  let(:standard_user) { create(:user, role: 'standard') }
  let(:admin_user) { create(:user, role: 'admin') }
  let(:inactive_user) { create(:user, role: 'standard', account_active: false) }
  let!(:staff_code) { create(:staff_code) }

  describe 'GET /staff_codes' do
    context 'when user is read_only' do
      before do
        request_login_as(read_only_user)
        request_stub_authorization(read_only_user)
      end

      it 'redirects to root path with alert' do
        get staff_codes_path
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('You are not authorized to access this page.')
      end
    end

    context 'when user is standard' do
      before do
        request_login_as(standard_user)
        request_stub_authorization(standard_user)
      end

      it 'redirects to root path with alert' do
        get staff_codes_path
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('You are not authorized to access this page.')
      end
    end

    context 'when user is admin' do
      before do
        request_login_as(admin_user)
        request_stub_authorization(admin_user)
      end

      it 'returns the staff codes page' do
        get staff_codes_path
        expect(response).to have_http_status(200)
        expect(response.body).to include('<h1>Staff Codes</h1>')
        expect(response.body).to include(staff_code.code)
        expect(response.body).to include(staff_code.points.to_s)
        expect(response.body).to include("href=\"#{new_staff_code_path}\">New Staff Code</a>")
        expect(response.body).to include("href=\"#{edit_staff_code_path(staff_code)}\">Edit</a>")
      end
    end

    context 'when user is not logged in' do
      it 'redirects to login page' do
        get staff_codes_path
        expect(response).to redirect_to(new_session_path)
        expect(flash[:alert]).to eq('You need to sign in before continuing.')
      end
    end

    context 'when user is inactive' do
      before do
        request_login_as(inactive_user)
        request_stub_authorization(inactive_user)
      end

      it 'shows an alert' do
        get staff_codes_path
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq('Your account is not active.')
      end
    end
  end

  describe 'GET /staff_codes/:id' do
    context 'when user is read_only' do
      before do
        request_login_as(read_only_user)
        request_stub_authorization(read_only_user)
      end

      it 'redirects to root path with alert' do
        get staff_code_path(staff_code)
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('You are not authorized to access this page.')
      end
    end

    context 'when user is standard' do
      before do
        request_login_as(standard_user)
        request_stub_authorization(standard_user)
      end

      it 'redirects to root path with alert' do
        get staff_codes_path(staff_code)
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('You are not authorized to access this page.')
      end
    end

    context 'when user is admin' do
      before do
        request_login_as(admin_user)
        request_stub_authorization(admin_user)
      end

      it 'returns the staff code page' do
        get staff_code_path(staff_code.id)
        expect(response).to have_http_status(200)

        # Parse the response body as HTML
        parsed_body = Nokogiri::HTML(response.body)

        # Check for specific content within the parsed HTML
        expect(parsed_body.text).to include(staff_code.code)
        expect(parsed_body.text).to include(staff_code.points.to_s)

        # Check for the absence of a specific link with the text "New Staff Code"
        expect(parsed_body.at_css('a:contains("New Staff Code")')).to be_nil

        # Check for the presence of specific links
        expect(parsed_body.at_css('a:contains("Edit")')).not_to be_nil
        expect(parsed_body.at_css('a:contains("Back")')).not_to be_nil
      end

      it 'returns a 404 for a non-existent staff_code' do
        get staff_code_path(id: 'non-existent-id')
        expect(response).to have_http_status(404)
      end
    end

    context 'when user is not logged in' do
      it 'redirects to login page' do
        request_logout
        get staff_code_path(staff_code)
        expect(response).to redirect_to(new_session_path)
        expect(flash[:alert]).to eq('You need to sign in before continuing.')
      end
    end

    context 'when user is inactive' do
      before do
        request_login_as(inactive_user)
        request_stub_authorization(inactive_user)
      end

      it 'redirects to root path with alert' do
        get staff_code_path(staff_code)
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('Your account is not active.')
      end
    end
  end
end
