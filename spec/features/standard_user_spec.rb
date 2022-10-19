# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Standard User Tests', type: :feature do
  let(:user) { create(:user, role: 'standard') }
  let(:conservation_record) { create(:conservation_record, department: 'ARB Library', title: 'Farewell to Arms') }
  let!(:staff_code) { create(:staff_code, code: 'test', points: 10) }

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
    expect(page).to have_content('Edit Conservation Record')

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

    # Show Staff Codes

    visit staff_codes_path
    expect(page).to have_content('Staff Codes')
    expect(page).to have_link('Destroy')
    expect(page).to have_link('Show')
    expect(page).to have_link('New Staff Code')

    # Edit Staff Codes

    visit staff_codes_path
    click_link('Edit')
    expect(page).to have_content('Editing Staff Code')

    # Add Staff Codes

    visit staff_codes_path
    click_link 'New Staff Code'
    expect(page).to have_content('New Staff Code')
    fill_in 'Code', with: staff_code.code
    fill_in 'Points', with: staff_code.points
    click_on 'Create Staff code'
    expect(page).to have_content('Staff code was successfully created')
    expect(page).to have_content(staff_code.code)
    expect(page).to have_link('Edit')

    # Edit the existing Staff Code

    click_link 'Edit'
    expect(page).to have_content('Editing Staff Code')

    # In_House Repair

    visit conservation_records_path
    click_link(conservation_record.title, match: :prefer_exact)
    expect(page).to have_button('Add In-House Repairs')
    click_button('Add In-House Repairs')
    select('Chuck Greenman', from: 'in_house_repair_record_performed_by_user_id')
    select('Soft slipcase', from: 'in_house_repair_record_repair_type', match: :first)
    fill_in 'in_house_repair_record_other_note', with: 'Other Note'
    fill_in 'in_house_repair_record_minutes_spent', with: '23'
    select('test', from: 'in_house_repair_record_staff_code_id', match: :first)
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
    expect(page).to have_button('Add Conservators and Technicians')
    click_button('Add Conservators and Technicians')
    select('John Green', from: 'con_tech_record_performed_by_user_id', match: :first)
    click_button('Create Conservators and Technicians Record')
    expect(page).to have_content('John Green')

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
    fill_in 'cost_return_report_note', with: 'Test cost and return note'
    click_button('Save Cost and Return Information')
    expect(page).to have_content('Test cost and return note')
  end
end
