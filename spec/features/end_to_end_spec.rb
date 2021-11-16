# frozen_string_literal: true

require 'rails_helper'

require 'capybara'

Capybara.register_driver :selenium_chrome_headless_sandboxless do |app|
  browser_options = ::Selenium::WebDriver::Chrome::Options.new
  browser_options.args << '--headless'
  browser_options.args << '--disable-gpu'
  browser_options.args << '--no-sandbox'
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: browser_options)
end
Capybara.default_driver = :rack_test # This is a faster driver
Capybara.javascript_driver = :selenium_chrome_headless_sandboxless

RSpec.describe 'Non-Authenticated User Tests', type: :feature do
  it 'asks user to login to view Conservation Records' do
    visit root_path
    expect(page).to have_link('Log in')
    expect(page).not_to have_link('Sign up')
  end
end

RSpec.describe 'Read Only User Tests', type: :feature, js: true do
  let(:user) { create(:user, role: 'read_only') }
  let(:conservation_record) { create(:conservation_record, title: 'Farewell to Arms', department: 'ARB Library') }
  it 'allows User to login and show Conservation Records' do
    # Login
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'notapassword'
    click_button 'Log in'
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

RSpec.describe 'Standard User Tests', type: :feature do
  let(:user) { create(:user, role: 'standard') }
  let!(:conservation_record) { create(:conservation_record, department: 'ARB Library', title: 'Farewell to Arms') }
  it 'allows User to login and show Conservation Records' do
    # Login
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'notapassword'
    click_button 'Log in'
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
    fill_in 'Imprint', with: 'University of Cincinnati Press'
    click_on 'Update Conservation record'
    expect(page).to have_content('Conservation record was successfully updated')
    expect(page).to have_content('University of Cincinnati Press')

    # Add New Conservation Record
    visit conservation_records_path
    click_on 'New Conservation Record'
    expect(page).to have_content('New Conservation Record')
    select('ARB Library', from: 'Department', match: :first)
    fill_in 'Title', with: conservation_record.title
    fill_in 'Author', with: conservation_record.author
    fill_in 'Imprint', with: conservation_record.imprint
    fill_in 'Call number', with: conservation_record.call_number
    fill_in 'Item record number', with: conservation_record.item_record_number
    click_on 'Create Conservation record'
    expect(page).to have_content('Conservation record was successfully created')
    expect(page).to have_content(conservation_record.title)
    expect(page).to have_link('Edit Conservation Record')

    # In_House Repair
    visit conservation_records_path
    click_link(conservation_record.title, match: :prefer_exact)
    expect(page).to have_button('Add In-House Repairs')
    click_button('Add In-House Repairs')
    select('Chuck Greenman', from: 'in_house_repair_record_performed_by_user_id')
    select('Soft slipcase', from: 'in_house_repair_record_repair_type', match: :first)
    click_button('Create In-House Repair Record')
    expect(page).to have_content('Soft slipcase performed by Chuck Greenman')

    # External Repair
    expect(page).to have_button('Add External Repair')
    click_button('Add External Repair')
    select('Amanda Buck', from: 'external_repair_record_performed_by_vendor_id', match: :first)
    select('Wash', from: 'external_repair_record_repair_type', match: :first)
    click_button('Create External Repair Record')
    expect(page).to have_content('Wash performed by Amanda Buck')

    # Conservators and Technicians
    expect(page).to have_no_button('Add Conservators and Technicians')

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
    expect(page).to have_content('You are not authorized to access this page')

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
    find("a[id='delete_conservation_record_#{conservation_record.id}']").click
    expect(page).to have_content('Conservation record was successfully destroyed.')
  end
end

RSpec.describe 'Admin User Tests', type: :feature do
  let(:user) { create(:user, role: 'admin') }
  let(:conservation_record) { create(:conservation_record, title: 'Farewell to Arms') }
  let(:vocabulary) { create(:controlled_vocabulary) }
  it 'allows User to login and show Conservation Records' do
    # Login
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'notapassword'
    click_button 'Log in'
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
    fill_in 'Display name', with: 'Beau Geste'
    fill_in 'Email', with: 'beau.geste@mail.uc.edu'
    fill_in 'Password', with: 'notapass'
    fill_in 'Password confirmation', with: 'notapass'
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
    fill_in 'Email', with: 'vytlasa@mail.uc.edu'
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
    select 'repair_type', from: 'Vocabulary'
    fill_in 'Key', with: 'key_string'
    check 'Active'
    click_button 'Create Controlled vocabulary'

    expect(page).to have_content('Controlled vocabulary was successfully created')

    # Edit vocabulary
    visit controlled_vocabularies_path
    click_on 'key_string'
    click_on 'Edit'
    fill_in 'Key', with: 'updated_key_string'
    click_on 'Update Controlled vocabulary'
    expect(page).to have_content('Controlled vocabulary was successfully updated.')
    expect(page).to have_content('updated_key_string')

    # Add New Conservation Record
    visit conservation_records_path
    click_on 'New Conservation Record'
    expect(page).to have_content('New Conservation Record')
    select('ARB Library', from: 'Department', match: :first)
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
    select('Haritha Vytla', from: 'in_house_repair_record_performed_by_user_id', match: :first)
    select('Mend paper', from: 'in_house_repair_record_repair_type', match: :first)
    click_button('Create In-House Repair Record')
    expect(page).to have_content('Mend paper performed by Haritha Vytla')

    # Delete In-house repair
    find("a[id='delete_in_house_repair_record_1']").click
    expect(page).not_to have_content('Mend paper performed by Haritha Vytla')

    # Create External Repair
    expect(page).to have_button('Add External Repair')
    click_button('Add External Repair')
    select('Amanda Buck', from: 'external_repair_record_performed_by_vendor_id', match: :first)
    select('Wash', from: 'external_repair_record_repair_type', match: :first)
    click_button('Create External Repair Record')
    expect(page).to have_content('Wash performed by Amanda Buck')

    # Delete external repair
    find("a[id='delete_external_repair_record_1']").click
    expect(page).not_to have_content('Wash performed by Amanda Buck')

    # Conservators and Technicians
    expect(page).to have_button('Add Conservators and Technicians')
    click_button('Add Conservators and Technicians')
    select('Haritha Vytla', from: 'con_tech_record_performed_by_user_id', match: :first)
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

    # Download Conservation Worksheet
    click_on 'Download Conservation Worksheet'
    expect(page.status_code).to eq(200)

    # Download Treatment Report
    visit conservation_record_path(conservation_record)
    click_on 'Download Treatment Report'
    expect(page.status_code).to eq(200)

    # Download Abbreviated Treatment Report
    visit conservation_record_path(conservation_record)
    first(:link, 'Download Abbreviated Treatment Report').click
    expect(page.status_code).to eq(200)

    # Verify logged activity
    visit activity_index_path
    expect(page).to have_content('Haritha Vytla created the user: Beau Geste')
    expect(page).to have_content('Haritha Vytla created the external repair record')
    expect(page).to have_content('Haritha Vytla deleted the external repair record')
    expect(page).to have_content('Haritha Vytla created the in house repair record')
    expect(page).to have_content('Haritha Vytla deleted the in house repair record')
    expect(page).to have_content('Haritha Vytla created the treatment report')
    expect(page).to have_content('Haritha Vytla updated the treatment report')
  end
end
