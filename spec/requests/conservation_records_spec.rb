# frozen_string_literal: true

require 'rails_helper'
require 'nokogiri'

RSpec.describe 'ConservationRecords', type: :request do
  let(:read_only_user) { create(:user, role: 'read_only') }
  let(:standard_user) { create(:user, role: 'standard') }
  let(:admin_user) { create(:user, role: 'admin') }
  let(:inactive_user) { create(:user, role: 'standard', account_active: false) }
  let!(:conservation_record) { create(:conservation_record) }

  describe 'GET /conservation_records' do
    context 'when user is read_only' do
      before do
        request_login_as(read_only_user)
      end

      it 'shows the conservation records page with appropriate content for the user' do
        get conservation_records_path
        expect(response).to have_http_status(200)

        # Parse the response body as HTML
        parsed_body = Nokogiri::HTML(response.body)

        # Check for the presence of an h1 with the text "Conservation Records"
        expect(parsed_body.at_css('h1').text).to eq('Conservation Records')

        # Check for the presence of specific content within the parsed HTML
        expect(parsed_body.text).to include(conservation_record.id.to_s)
        expect(parsed_body.text).to include(conservation_record.title)
        expect(parsed_body.text).to include(conservation_record.author)
        expect(parsed_body.text).to include(conservation_record.call_number.to_s)
        expect(parsed_body.text).to include(conservation_record.item_record_number.to_s)

        # Check for the absence of a specific link with the text "New Conservation Record"
        expect(parsed_body.at_css('a:contains("New Conservation Record")')).to be_nil

        # Check for the presence of a link with the conservation record's title and correct href
        expect(parsed_body.at_css("a[href='#{conservation_record_path(conservation_record)}']").text).to eq(conservation_record.title)

        # Check for the absence of an img tag with a delete icon and alt="Delete"
        expect(parsed_body.at_css('img.delete-icon[alt="Delete"]')).to be_nil
      end
    end

    context 'when user is standard' do
      before do
        request_login_as(standard_user)
      end

      it 'shows the conservation records page with appropriate content for the user' do
        get conservation_records_path
        expect(response).to have_http_status(200)
        # Parse the response body as HTML
        parsed_body = Nokogiri::HTML(response.body)

        # Check for the presence of an h1 with the text "Conservation Records"
        expect(parsed_body.at_css('h1').text).to eq('Conservation Records')

        # Check for the presence of specific content within the parsed HTML
        expect(parsed_body.text).to include(conservation_record.id.to_s)
        expect(parsed_body.text).to include(conservation_record.title)
        expect(parsed_body.text).to include(conservation_record.author)
        expect(parsed_body.text).to include(conservation_record.call_number.to_s)
        expect(parsed_body.text).to include(conservation_record.item_record_number.to_s)

        # Check for the presence of a specific link with the text "New Conservation Record"
        expect(parsed_body.at_css('a:contains("New Conservation Record")')).not_to be_nil

        # Check for the presence of a link with the conservation record's title and correct href
        expect(parsed_body.at_css("a[href='#{conservation_record_path(conservation_record)}']").text).to eq(conservation_record.title)

        # Check for the presence of an img tag with a delete icon and alt="Delete"
        expect(parsed_body.at_css('img.delete-icon[alt="Delete"]')).not_to be_nil
      end
    end

    context 'when user is admin' do
      before do
        request_login_as(admin_user)
      end

      it 'shows the conservation records page with appropriate content for the user' do
        get conservation_records_path
        expect(response).to have_http_status(200)
        # Parse the response body as HTML
        parsed_body = Nokogiri::HTML(response.body)

        # Check for the presence of an h1 with the text "Conservation Records"
        expect(parsed_body.at_css('h1').text).to eq('Conservation Records')

        # Check for the presence of specific text content within the parsed HTML
        expect(parsed_body.text).to include(conservation_record.id.to_s)
        expect(parsed_body.text).to include(conservation_record.title)
        expect(parsed_body.text).to include(conservation_record.author)
        expect(parsed_body.text).to include(conservation_record.call_number.to_s)
        expect(parsed_body.text).to include(conservation_record.item_record_number.to_s)

        # Check for the presence of a link with href for creating a new conservation record
        expect(parsed_body.at_css("a[href='#{new_conservation_record_path}']").text).to eq('New Conservation Record')

        # Check for the presence of a link with the conservation record's title and correct href
        expect(parsed_body.at_css("a[href='#{conservation_record_path(conservation_record)}']").text).to eq(conservation_record.title)

        # Check for the presence of an img tag with a delete icon and alt="Delete"
        expect(parsed_body.at_css('img.delete-icon[alt="Delete"]')).not_to be_nil
      end
    end

    context 'when user is not logged in' do
      it 'redirects to root page' do
        get controlled_vocabularies_path
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('You need to sign in before continuing.')
      end
    end

    context 'when user is inactive' do
      before do
        request_login_as(inactive_user)
      end

      it 'shows an alert' do
        get controlled_vocabularies_path
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq('Your account is not active.')
      end
    end
  end

  describe 'GET /conservation_records/:id' do
    context 'when user is read_only' do
      before do
        request_login_as(read_only_user)
      end

      it 'shows the conservation record with appropriate permissions' do
        get conservation_record_path(conservation_record)
        expect(response).to have_http_status(200)

        # Parse the response body as HTML
        parsed_body = Nokogiri::HTML(response.body)

        expect(parsed_body.at_css("a[href='#{conservation_records_path}']:contains('← Return to List')")).not_to be_nil
        expect(parsed_body.at_css('h1').text).to include(conservation_record.title)
        expect(parsed_body.at_css('a:contains("Edit Conservation Record")')).to be_nil
        expect(parsed_body.at_css('a:contains("Download Conservation Worksheet")')).not_to be_nil
        expect(parsed_body.text).to include(conservation_record.id.to_s)
        expect(parsed_body.text).to include(conservation_record.title)
        expect(parsed_body.text).to include(conservation_record.author)
        expect(parsed_body.text).to include(conservation_record.call_number.to_s)
        expect(parsed_body.text).to include(conservation_record.item_record_number.to_s)
        expect(parsed_body.at_css('h3:contains("In-House Repairs")')).not_to be_nil
        expect(parsed_body.at_css('a:contains("Add In-House Repairs")')).to be_nil
        expect(parsed_body.at_css('h3:contains("External Repairs")')).not_to be_nil
        expect(parsed_body.at_css('a:contains("Add External Repair")')).to be_nil
        expect(parsed_body.at_css('h3:contains("Conservators and Technicians")')).not_to be_nil
        expect(parsed_body.at_css('a:contains("Add Conservators and Technicians")')).to be_nil
        expect(parsed_body.at_css('h3:contains("Treatment Report")')).not_to be_nil
        expect(parsed_body.at_css('h3:contains("Cost and Return Information")')).not_to be_nil
        expect(parsed_body.at_css('a:contains("Download Abbreviated Treatment Report")')).not_to be_nil
      end
    end

    context 'when user is standard' do
      before do
        request_login_as(standard_user)
      end

      it 'shows the conservation record with appropriate permissions' do
        get conservation_record_path(conservation_record)
        expect(response).to have_http_status(200)
        # Parse the response body as HTML
        parsed_body = Nokogiri::HTML(response.body)

        # Check for the presence of a link with href for returning to the list
        expect(parsed_body.at_css("a[href='#{conservation_records_path}'][text()='← Return to List']")).not_to be_nil

        # Check for the presence of an h1 with the conservation record title
        expect(parsed_body.at_css('h1').text).to eq(conservation_record.title)

        # Check for the presence of a link to edit the conservation record
        expect(parsed_body.at_css("a[href='#{edit_conservation_record_path(conservation_record)}']").text).to eq('Edit Conservation Record')

        # Check for the presence of a link to download the conservation worksheet
        expect(parsed_body.at_css('a:contains("Download Conservation Worksheet")')).not_to be_nil

        # Check for the presence of specific text content within the parsed HTML
        expect(parsed_body.text).to include(conservation_record.id.to_s)
        expect(parsed_body.text).to include(conservation_record.title)
        expect(parsed_body.text).to include(conservation_record.author)
        expect(parsed_body.text).to include(conservation_record.call_number.to_s)
        expect(parsed_body.text).to include(conservation_record.item_record_number.to_s)

        expect(parsed_body.at_css('h3:contains("In-House Repairs")')).not_to be_nil
        expect(
          parsed_body.at_css(
            'button.btn.btn-primary.cta-btn' \
            '[data-bs-toggle="modal"]' \
            '[data-bs-target="#inHouseRepairModal"]'
          ).text.strip
        ).to eq('Add In-House Repairs')

        expect(parsed_body.at_css('h3:contains("External Repairs")')).not_to be_nil
        expect(
          parsed_body.at_css(
            'button.btn.btn-primary.cta-btn' \
            '[data-bs-toggle="modal"]' \
            '[data-bs-target="#externalRepairModal"]'
          ).text.strip
        ).to eq('Add External Repair')

        expect(parsed_body.at_css('h3:contains("Conservators and Technicians")')).not_to be_nil
        expect(
          parsed_body.at_css(
            'button.btn.btn-primary.cta-btn' \
            '[data-bs-toggle="modal"]' \
            '[data-bs-target="#ConservatorsTechniciansModal"]'
          ).text.strip
        ).to eq('Add Conservators and Technicians')

        expect(parsed_body.at_css('h3:contains("Treatment Report")')).not_to be_nil
        expect(
          parsed_body.at_css(
            'input[type="submit"]' \
            '[name="commit"]' \
            '[value="Save Treatment Report"]' \
            '[class="btn btn-primary"]' \
            '[data-disable-with="Save Treatment Report"]'
          )
        ).not_to be_nil

        expect(parsed_body.at_css('h3:contains("Cost and Return Information")')).not_to be_nil
        expect(parsed_body.at_css('a:contains("Download Abbreviated Treatment Report")')).not_to be_nil
      end
    end

    context 'when user is admin' do
      before do
        request_login_as(admin_user)
      end

      it 'shows the conservation record with appropriate permissions' do
        get conservation_record_path(conservation_record)
        expect(response).to have_http_status(200)
        # Parse the response body as HTML
        parsed_body = Nokogiri::HTML(response.body)

        # Check for the presence of a link with href for returning to the list
        expect(parsed_body.at_css("a[href='#{conservation_records_path}'][text()='← Return to List']")).not_to be_nil

        # Check for the presence of an h1 with the conservation record title
        expect(parsed_body.at_css('h1').text).to eq(conservation_record.title)

        # Check for the presence of a link to edit the conservation record
        expect(parsed_body.at_css("a[href='#{edit_conservation_record_path(conservation_record)}']").text).to eq('Edit Conservation Record')

        # Check for the presence of a link to download the conservation worksheet
        expect(parsed_body.at_css('a:contains("Download Conservation Worksheet")')).not_to be_nil

        # Check for the presence of specific text content within the parsed HTML
        expect(parsed_body.text).to include(conservation_record.id.to_s)
        expect(parsed_body.text).to include(conservation_record.title)
        expect(parsed_body.text).to include(conservation_record.author)
        expect(parsed_body.text).to include(conservation_record.call_number.to_s)
        expect(parsed_body.text).to include(conservation_record.item_record_number.to_s)

        expect(parsed_body.at_css('h3:contains("In-House Repairs")')).not_to be_nil
        expect(
          parsed_body.at_css(
            'button.btn.btn-primary.cta-btn' \
            '[data-bs-toggle="modal"]' \
            '[data-bs-target="#inHouseRepairModal"]'
          ).text.strip
        ).to eq('Add In-House Repairs')

        expect(
          parsed_body.at_css(
            'button.btn.btn-primary.cta-btn' \
            '[data-bs-toggle="modal"]' \
            '[data-bs-target="#externalRepairModal"]'
          ).text.strip
        ).to eq('Add External Repair')

        expect(parsed_body.at_css('h3:contains("External Repairs")')).not_to be_nil
        expect(parsed_body.at_css('h3:contains("Conservators and Technicians")')).not_to be_nil
        expect(
          parsed_body.at_css(
            'button.btn.btn-primary.cta-btn' \
            '[data-bs-toggle="modal"]' \
            '[data-bs-target="#ConservatorsTechniciansModal"]'
          ).text.strip
        ).to eq('Add Conservators and Technicians')

        expect(parsed_body.at_css('h3:contains("Treatment Report")')).not_to be_nil
        expect(
          parsed_body.at_css(
            'input[type="submit"][name="commit"]' \
            '[value="Save Treatment Report"]' \
            '[class="btn btn-primary"]' \
            '[data-disable-with="Save Treatment Report"]'
          )
        ).not_to be_nil

        expect(parsed_body.at_css('h3:contains("Cost and Return Information")')).not_to be_nil
        expect(parsed_body.at_css('a:contains("Download Abbreviated Treatment Report")')).not_to be_nil
      end

      it 'returns a 404 for a non-existent conservation record' do
        get conservation_record_path(id: 'non-existent-id')
        expect(response).to have_http_status(404)
      end
    end

    context 'when user is not logged in' do
      it 'redirects to root page' do
        get conservation_record_path(conservation_record)
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('You need to sign in before continuing.')
      end
    end

    context 'when user is inactive' do
      before do
        request_login_as(inactive_user)
      end

      it 'redirects to root path with alert' do
        get conservation_record_path(conservation_record)
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('Your account is not active.')
      end
    end
  end
end
