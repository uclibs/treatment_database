# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Non-Authenticated User Tests', type: :feature do
  it 'asks user to login to view Conservation Records' do
    visit root_path
    expect(page).to have_button('Sign In')
    expect(page).not_to have_content('Sign up')
  end
end

RSpec.describe 'Read Only User Tests', type: :feature, js: true do
  let(:user) { create(:user, role: 'read_only') }
  let(:conservation_record) { create(:conservation_record, title: 'Farewell to Arms') }

  it 'allows User to login and show Conservation Records' do
    visit dev_login_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Submit'
    expect(page).to have_content('Signed in successfully')
    expect(page).to have_content('Conservation Records')
    expect(page).to have_link('Conservation Records')

    # Show Conservation Records
    click_on 'Conservation Records'
    expect(page).to have_content('Conservation Records')
    expect(page).to have_no_link('Add Conservation Record')
    expect(page).to have_no_link('Destroy')
    expect(page).to have_no_link('Edit', text: 'Edit', exact_text: true)
    expect(page).to have_no_link('Show')

    # CRUD
    click_link(conservation_record.title, match: :prefer_exact)
    expect(page).to have_content(conservation_record.title)
    expect(page).to have_content('Item Detail')
    expect(page).to have_content('In-House Repairs')
    expect(page).to have_content('External Repairs')
    expect(page).to have_content('Conservators and Technicians')
    expect(page).to have_content('Treatment Report')
    expect(page).to have_button('Save Treatment Report', disabled: true)
    expect(page).to have_content('Cost and Return Information')
    expect(page).to have_button('Save Cost and Return Information', disabled: true)
    expect(page).to have_no_link('Edit Conservation Record')
    expect(page).to have_no_button('Add In-House Repairs')
    expect(page).to have_no_button('Add External Repair')
    expect(page).to have_no_button('Add Conservators and Technicians')
    expect(page).to have_button('Save Treatment Report', disabled: true)
    expect(page).to have_button('Save Cost and Return Information', disabled: true)
  end
end

RSpec.describe 'Standard User Tests', type: :feature, versioning: true, js: true do
  let(:user) { create(:user, role: 'standard') }
  let!(:conservation_record) { create(:conservation_record, title: 'Farewell to Arms') }
  let!(:staff_code) { create(:staff_code, code: 'test', points: 10) }
  let(:today_date) { Time.zone.today.strftime('%Y-%m-%d') }

  it 'allows User to login and show Conservation Records' do
    # Login
    visit dev_login_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'notapassword'
    click_button 'Submit'
    expect(page).to have_content('Signed in successfully')
    expect(page).to have_link('Conservation Records')
    expect(page).to have_no_link('Users')
    expect(page).to have_no_link('Activity')
    expect(page).to have_no_link('Vocabularies')

    # Show Conservation Records
    click_on 'Conservation Records'
    expect(page).to have_content('Conservation Records')
    expect(page).to_not have_link('Destroy')
    expect(page).to_not have_link('Show')
    expect(page).to have_link('New Conservation Record')

    # Edit Conservation Record
    visit conservation_records_path
    click_link(conservation_record.title, match: :prefer_exact)
    click_link('Edit Conservation Record')
    expect(page).to have_content('Editing Conservation Record')
    # Check that selected shows on edit
    fill_in 'Imprint', with: 'University of Cincinnati Press'
    click_on 'Update Conservation record'
    expect(page).to have_content('Conservation record was successfully updated')
    expect(page).to have_content('University of Cincinnati Press')

    # Add New Conservation Record
    visit conservation_records_path
    click_on 'New Conservation Record'
    expect(page).to have_content('New Conservation Record')
    fill_in 'Date received in preservation services', with: today_date
    select('PLCH', from: 'Department', match: :first)
    fill_in 'Title', with: conservation_record.title
    fill_in 'Author', with: conservation_record.author
    fill_in 'Imprint', with: conservation_record.imprint
    fill_in 'Call number', with: conservation_record.call_number
    fill_in 'Item record number', with: conservation_record.item_record_number
    click_on 'Create Conservation record'
    expect(page).to have_content('Conservation record was successfully created')
    expect(page).to have_content(conservation_record.title)
    expect(page).to have_link('Edit Conservation Record')
    click_on 'Edit Conservation Record'
    expect(page).to have_select('conservation_record_department', selected: 'PLCH')

    # In_House Repair
    visit conservation_records_path
    click_link(conservation_record.title, match: :prefer_exact)
    expect(page).to have_button('Add In-House Repairs')
    click_button('Add In-House Repairs')
    expect(page).to have_button('Create In-House Repair Record')
    select('Chuck Greenman', from: 'in_house_performed_by_user_id', match: :first)
    select('Soft slipcase', from: 'in_house_repair_type', match: :first)
    fill_in('in_house_other_note', with: 'Some Other note for the in-house repair')
    fill_in('in_house_minutes_spent', with: '2')
    select('test', from: 'in_house_staff_code_id', match: :first)
    click_button('Create In-House Repair Record')
    expect(page).to have_content('Soft slipcase performed by Chuck Greenman in 2 minutes. Other note: Some Other note for the in-house repair')

    # External Repair
    # Wait for the button to be visible and clickable, then click it
    expect(page).to have_button('Add External Repair', visible: true, wait: 10)
    find_button('Add External Repair', visible: true).click

    # Ensure the modal has opened by checking for an element unique to the modal
    within('#externalRepairModal') do
      expect(page).to have_content('Repaired By', wait: 10)
    end

    expect(page).to have_button('Create External Repair Record')
    expect(page).to have_select('performed_by_vendor_id', visible: true, wait: 5)
    select('Amanda Buck', from: 'performed_by_vendor_id', match: :first)
    select('Wash', from: 'external_repair_type', match: :first)
    fill_in('external_other_note', with: 'Some Other note for the external repair')
    click_button('Create External Repair Record')
    expect(page).to have_content('Wash performed by Amanda Buck. Other note: Some Other note for the external repair')

    # Conservators and Technicians
    expect(page).to have_button('Add Conservators and Technicians')
    click_button('Add Conservators and Technicians')
    dropdown = find('#cons_tech_performed_by_user_id', visible: true, wait: 15)
    dropdown.find('option', text: 'John Green').select_option
    click_button('Create Conservators and Technicians Record')
    expect(page).to have_content('John Green', wait: 15)

    # Save Treatment Report
    expect(page).to have_content('Treatment Report')
    click_on 'Description'
    fill_in 'treatment_report_description_general_remarks', with: nil
    fill_in 'treatment_report_description_binding', with: 'Full leather tightjoint, tight back binding'
    fill_in 'treatment_report_description_textblock',
            with: 'The first section is loose at the head. An insert has been placed between the back board ad the text of the book'
    fill_in 'treatment_report_description_primary_support', with: nil
    fill_in 'treatment_report_description_medium', with: nil
    fill_in 'treatment_report_description_attachments_inserts', with: nil
    fill_in 'treatment_report_description_housing', with: nil
    click_on 'Condition'
    fill_in 'treatment_report_condition_summary', with: nil
    fill_in 'treatment_report_condition_previous_treatment', with: nil
    fill_in 'treatment_report_condition_materials_analysis', with: nil
    click_on 'Treatment Proposal'
    fill_in 'treatment_report_treatment_proposal_proposal', with: 'Reattach the front board and stabilize the back board with kozo fiber paper hinges'
    select('Portfolio', from: 'treatment_report_treatment_proposal_housing_need_id', match: :first)
    fill_in 'treatment_report_treatment_proposal_performed_treatment',
            with: ' Reattached the front board with a usu-mino thin kozo fiber hinge. The back board was reinforced with the same paper'
    select('Portfolio', from: 'treatment_report_treatment_proposal_housing_provided_id', match: :first)
    fill_in 'treatment_report_treatment_proposal_total_treatment_time', with: 10
    click_button('Save Treatment Report')
    expect(page).to have_content('Treatment Record updated successfully!')
    click_on 'Treatment Proposal'
    expect(page).to have_content('Housing Need')
    expect(page).to have_select('treatment_report_treatment_proposal_housing_need_id', selected: ['Portfolio'])
    expect(page).to have_select('treatment_report_treatment_proposal_housing_provided_id', selected: ['Portfolio'])

    # Save Cost Return Information
    expect(page).to have_content('Cost and Return Information')
    fill_in 'cost_return_report_shipping_cost', with: 100
    fill_in 'cost_return_report_repair_estimate', with: 100
    fill_in 'cost_return_report_repair_cost', with: 100
    fill_in 'cost_return_report_invoice_sent_to_business_office', with: Time.zone.today.strftime('%Y-%m-%d')
    fill_in 'cost_return_report_note', with: 'Test cost & return info'
    click_button('Save Cost and Return Information')
    expect(page).to have_content('Test cost & return info')

    # Search
    expect(page).to have_button('Search', disabled: false)
    click_button 'Search'
    expect(page).to have_content('Searching for')

    # Search for item record number
    fill_in 'Search', with: conservation_record.item_record_number
    click_button 'Search'
    expect(page).to have_content("Searching for #{conservation_record.item_record_number}")
    expect(page).to have_content(conservation_record.title)

    # Delete conservation record
    visit conservation_records_path
    expect(page).to have_selector("a[id='delete_conservation_record_#{conservation_record.id}']")
    accept_confirm(wait: 5) do
      find("a[id='delete_conservation_record_#{conservation_record.id}']").click
    end
    expect(page).to have_content('Conservation record was successfully destroyed.')
  end
end

RSpec.describe 'Admin User Tests', type: :feature, versioning: true, js: true do
  let(:user) { create(:user, role: 'admin') }
  let!(:conservation_record) { create(:conservation_record, title: 'Farewell to Arms') }
  let(:vocabulary) { create(:controlled_vocabulary) }
  let!(:staff_code) { create(:staff_code, code: 'test', points: 10) }
  let(:today_date) { Time.zone.today.strftime('%Y-%m-%d') }

  it 'allows User to login and show Conservation Records' do
    # Login
    visit dev_login_path
    expect(page).to have_content('Please sign in to continue') # Prompt only visible on Dev login page
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'notapassword'
    click_button 'Submit'
    expect(page).to have_content('Signed in successfully')
    expect(page).to have_link('Conservation Records')

    # Show Conservation Records
    click_on 'Conservation Records'
    expect(page).to have_content('Conservation Records')
    expect(page).to have_css('.delete-icon')
    expect(page).to_not have_link('Show')
    expect(page).to have_link('New Conservation Record')
    expect(page).to have_content(conservation_record.title)

    # Edit Conservation Record
    visit conservation_records_path
    click_link(conservation_record.title, match: :prefer_exact)
    expect(page).to have_content('Edit Conservation Record')

    # Create User
    visit conservation_records_path
    click_on 'Users'
    expect(page).to have_content('Users')
    click_on 'Add New User'
    expect(page).to have_content('Create New User')
    fill_in 'Display Name', with: 'Beau Geste'
    fill_in 'Email', with: 'beau.geste@uc.edu'
    fill_in 'User Password', with: 'notapassword'
    fill_in 'User Password Confirmation', with: 'notapassword'
    select('Admin', from: 'Role')
    click_on 'Create User'
    expect(page).to have_content('Beau Geste')

    # Edit Users
    visit conservation_records_path
    click_on 'Users'
    expect(page).to have_content('Users')
    click_link(user.display_name, match: :prefer_exact)

    expect(page).to have_content('Edit User')
    fill_in 'Display name', with: 'Haritha Vytla'
    fill_in 'Email', with: 'vytlasa@uc.edu'
    select('Admin', from: 'Role')
    click_on 'Update User'
    expect(page).to have_content('Haritha Vytla')

    # View Activity
    visit conservation_records_path
    click_link('Activity')
    expect(page).to have_content('Recent Activity')
    expect(page).to have_content('updated the user: Haritha Vytla')

    # Add Vocabulary
    visit conservation_records_path
    click_link('Vocabularies')
    expect(page).to have_content('Controlled Vocabularies')
    click_link('New Controlled Vocabulary')
    expect(page).to have_content('New Controlled Vocabulary')
    select 'repair_type', from: 'controlled_vocabulary_vocabulary'
    fill_in 'Key', with: 'key_string'
    check 'Active'
    click_button 'Create Controlled vocabulary'
    expect(page).to have_content('Controlled vocabulary was successfully created')

    # Edit vocabulary
    visit controlled_vocabularies_path
    expect(page).to have_content('Controlled Vocabularies')
    first(:link, 'key_string').click
    expect(page).to have_selector('h1', text: 'Vocabulary: repair_type')
    click_on 'Edit'
    expect(page).to have_selector('h1', text: 'Editing Controlled Vocabulary')
    fill_in 'Key', with: 'updated_key_string'
    check 'Favorite'
    click_on 'Update Controlled vocabulary'
    expect(page).to have_content('Controlled vocabulary was successfully updated.')
    expect(page).to have_content('updated_key_string')

    # Add New Conservation Record
    visit conservation_records_path
    click_on 'New Conservation Record'
    expect(page).to have_content('New Conservation Record')
    fill_in 'Date received in preservation services', with: today_date
    select('PLCH', from: 'Department', match: :first)
    fill_in 'Title', with: conservation_record.title
    fill_in 'Author', with: conservation_record.author
    fill_in 'Imprint', with: conservation_record.imprint
    fill_in 'Call number', with: conservation_record.call_number
    fill_in 'Item record number', with: conservation_record.item_record_number
    click_on 'Create Conservation record'
    expect(page).to have_content('Conservation record was successfully created')
    expect(page).to have_content(conservation_record.title)
    expect(page).to have_link('Edit Conservation Record')

    # Edit the existing Conservation Record

    click_on 'Edit Conservation Record'
    expect(page).to have_content('Editing Conservation Record')

    # Create In_House Repair
    visit conservation_records_path
    click_link(conservation_record.title, match: :prefer_exact)
    expect(page).to have_button('Add In-House Repairs')
    click_button('Add In-House Repairs')
    select('Haritha Vytla', from: 'in_house_performed_by_user_id', match: :first)
    # get list of repair_types and check that favorite is first option
    repair_types = find('#in_house_repair_type').all('option').collect(&:text)
    expect(repair_types[1..]).to start_with('updated_key_string')
    select('Mend paper', from: 'in_house_repair_type', match: :first)
    fill_in('in_house_other_note', with: 'Some Other note for the in-house repair')
    fill_in('in_house_minutes_spent', with: '2')
    select('test', from: 'in_house_staff_code_id', match: :first)
    click_button('Create In-House Repair Record')
    expect(page).to have_content('Mend paper performed by Haritha Vytla in 2 minutes. Other note: Some Other note for the in-house repair')

    # Delete In-house repair
    # Ensure the delete link is present and visible
    expect(page).to have_selector("a[id='delete_in_house_repair_record_1']", visible: true, wait: 10)
    find("a[id='delete_in_house_repair_record_1']", visible: true)

    # Click the delete link within a confirmation dialog
    retries = 3
    begin
      accept_confirm do
        find("a[id='delete_in_house_repair_record_1']").click
      end
    rescue Capybara::ModalNotFound
      retries -= 1
      retry if retries.positive?
      raise
    end

    # Verify the content has been removed
    expect(page).not_to have_content('Mend paper performed by Haritha Vytla', wait: 10)

    # Create External Repair
    # Wait for the button to be visible and clickable, then click it
    expect(page).to have_button('Add External Repair', visible: true, wait: 10)
    find_button('Add External Repair', visible: true).click

    retries = 3
    begin
      within('#externalRepairModal') do
        expect(page).to have_content('Repaired By', wait: 5)
      end
    rescue Capybara::ModalNotFound
      retries -= 1
      retry if retries.positive?
      raise
    end

    expect(page).to have_button('Create External Repair Record')
    expect(page).to have_select('performed_by_vendor_id', visible: true, wait: 5)
    select('Amanda Buck', from: 'performed_by_vendor_id', match: :first)
    select('Wash', from: 'external_repair_type', match: :first)
    fill_in('external_other_note', with: 'Some Other note for the external repair')
    click_button('Create External Repair Record')
    expect(page).to have_content('Wash performed by Amanda Buck. Other note: Some Other note for the external repair')

    # Delete external repair
    expect(page).to have_selector("a[id='delete_external_repair_record_1']")
    accept_confirm(wait: 15) do
      find("a[id='delete_external_repair_record_1']").click
    end
    expect(page).not_to have_content('Wash performed by Amanda Buck', wait: 5)

    # Conservators and Technicians
    expect(page).to have_button('Add Conservators and Technicians')
    click_button('Add Conservators and Technicians')
    # Ensure the dropdown is visible and enabled before interacting with it
    expect(page).to have_select('cons_tech_performed_by_user_id', visible: true, wait: 10)
    select('Haritha Vytla', from: 'cons_tech_performed_by_user_id', match: :first)
    click_button('Create Conservators and Technicians Record')
    expect(page).to have_content('Haritha Vytla')

    # Save Treatment Report
    expect(page).to have_content('Treatment Report')
    click_on 'Description'
    fill_in 'treatment_report_description_general_remarks', with: nil
    fill_in 'treatment_report_description_binding', with: 'Full leather tightjoint, tight back binding'
    fill_in 'treatment_report_description_textblock',
            with: 'The first section is loose at the head. An insert has been placed between the back board ad the text of the book'
    fill_in 'treatment_report_description_primary_support', with: nil
    fill_in 'treatment_report_description_medium', with: nil
    fill_in 'treatment_report_description_attachments_inserts', with: nil
    fill_in 'treatment_report_description_housing', with: nil
    click_on 'Condition'
    fill_in 'treatment_report_condition_summary', with: nil
    fill_in 'treatment_report_condition_previous_treatment', with: nil
    fill_in 'treatment_report_condition_materials_analysis', with: nil
    click_on 'Treatment Proposal'
    fill_in 'treatment_report_treatment_proposal_proposal', with: 'Reattach the front board and stabilize the back board with kozo fiber paper hinges'
    select('Portfolio', from: 'treatment_report_treatment_proposal_housing_need_id', match: :first)
    fill_in 'treatment_report_treatment_proposal_performed_treatment',
            with: ' Reattached the front board with a usu-mino thin kozo fiber hinge. The back board was reinforced with the same paper'
    select('Portfolio', from: 'treatment_report_treatment_proposal_housing_provided_id', match: :first)
    fill_in 'treatment_report_treatment_proposal_total_treatment_time', with: 10
    click_button('Save Treatment Report')
    expect(page).to have_content('Treatment Record updated successfully!')

    # Save Cost Return Information
    expect(page).to have_content('Cost and Return Information')
    fill_in 'cost_return_report_shipping_cost', with: 100
    fill_in 'cost_return_report_repair_estimate', with: 100
    fill_in 'cost_return_report_repair_cost', with: 100
    fill_in 'cost_return_report_invoice_sent_to_business_office', with: Time.zone.today.strftime('%Y-%m-%d')
    fill_in 'cost_return_report_note', with: nil
    click_button('Save Cost and Return Information')
    expect(page).to have_content('Treatment record updated')

    # Search for conservation record id
    fill_in 'Search', with: conservation_record.id
    click_button 'Search'
    expect(page).to have_content('Item Detail')
    expect(page).to have_content(conservation_record.title)

    # Verify the Conservation Worksheet link and return to the original page
    verify_download_link('Download Conservation Worksheet')
    expect(page).to have_content(conservation_record.title)

    # Verify the Treatment Report link and return to the original page
    verify_download_link('Download Treatment Report')
    expect(page).to have_content(conservation_record.title)

    # Verify the Abbreviated Treatment Report link and return to the original page
    verify_download_link('Download Abbreviated Treatment Report')

    # Verify logged activity
    visit activity_index_path
    expect(page).to have_content('Haritha Vytla created the user: Beau Geste')
    expect(page).to have_content('Haritha Vytla created the external repair record')
    expect(page).to have_content('Haritha Vytla deleted the external repair record')
    expect(page).to have_content('Haritha Vytla created the in house repair record')
    expect(page).to have_content('Haritha Vytla deleted the in house repair record')
    expect(page).to_not have_content('Haritha Vytla created the treatment report')
    expect(page).to have_content('Haritha Vytla updated the treatment report')

    # Check that details page shows diff data
    visit conservation_records_path
    click_link(conservation_record.title, match: :prefer_exact)
    fill_in 'treatment_report_description_binding', with: 'Half leather tightjoint, tight back binding'
    click_button('Save Treatment Report')
    expect(page).to have_content('Treatment Record updated successfully!')
    visit activity_index_path
    expect(page).to have_content('Haritha Vytla updated the treatment report')
    within first('tbody tr') do
      click_link 'Details'
    end
    expect(page).to have_content('Full leather tightjoint, tight back binding')
    expect(page).to have_content('Half leather tightjoint, tight back binding')
  end
end
