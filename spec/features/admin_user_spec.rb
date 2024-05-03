# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin User Tests', type: :feature, versioning: true do
  let!(:staff_code) { create(:staff_code, code: 'test', points: 10) }
  let(:user) { create(:user, role: 'admin') }
  let(:conservation_record) { create(:conservation_record, title: 'Farewell to Arms', department: 2) }
  let(:vocabulary) { create(:controlled_vocabulary) }

  it 'allows User to login and show Conservation Records and Staff Codes' do
    # Login
    log_in_as_user(user)

    # View Activity
    visit conservation_records_path
    click_link('Activity')
    expect(page).to have_content('Recent Activity')

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

    # Go to a Conservation Record to edit it
    visit conservation_records_path
    within('table tbody') do
      first('a').click
    end

    # In_House Repair

    visit conservation_records_path
    click_link(conservation_record.title, match: :prefer_exact)
    expect(page).to have_button('Add In-House Repairs')
    click_button('Add In-House Repairs')
    select(user.display_name, from: 'in_house_repair_record_performed_by_user_id', match: :first)
    select('Mend paper', from: 'in_house_repair_record_repair_type', match: :first)
    fill_in 'in_house_repair_record_minutes_spent', with: '10'
    fill_in 'in_house_repair_record_other_note', with: 'Other Note'
    select('test', from: 'in_house_repair_record_staff_code_id', match: :first)
    click_button('Create In-House Repair Record')
    expect(page).to have_content("Mend paper performed by #{user.display_name}")

    # External Repair
    expect(page).to have_button('Add External Repair')
    click_button('Add External Repair')
    expect(page).to have_selector('#externalRepairModal', visible: true)
    select('Amanda Buck', from: 'external_repair_record_performed_by_vendor_id', match: :first)
    select('Wash', from: 'external_repair_record_repair_type', match: :first)
    click_button('Create External Repair Record')
    expect(page).to have_content('Wash performed by Amanda Buck')

    # Conservators and Technicians
    expect(page).to have_button('Add Conservators and Technicians')
    click_button('Add Conservators and Technicians')
    select(user.display_name, from: 'con_tech_record_performed_by_user_id', match: :first)
    click_button('Create Conservators and Technicians Record')
    expect(page).to have_content(user.display_name)

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
  end
end
