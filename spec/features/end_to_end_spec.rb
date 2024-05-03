# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Read Only User Tests', type: :feature, js: true do
  let(:user) { create(:user, role: 'read_only') }
  let(:conservation_record) { create(:conservation_record, title: 'Farewell to Arms') }
  it 'allows User to login and show Conservation Records' do
    # Login
    log_in_as_user(user)

    # CRUD
    click_link(conservation_record.title, match: :prefer_exact)

    expect(page).to have_button('Save Treatment Report', disabled: true)
    expect(page).to have_button('Save Cost and Return Information', disabled: true)
    expect(page).to have_button('Save Treatment Report', disabled: true)
    expect(page).to have_button('Save Cost and Return Information', disabled: true)
  end
end

RSpec.describe 'Standard User Tests', type: :feature, versioning: true do
  let!(:staff_code) { create(:staff_code, code: 'test', points: 10) }
  let(:user) { create(:user, role: 'standard') }
  let!(:conservation_record) { create(:conservation_record, title: 'Farewell to Arms') }

  before do
    @departments = ControlledVocabulary.where(vocabulary: 'department')
  end

  it 'allows User to login and show Conservation Records' do
    # Login
    log_in_as_user(user)

    # In_House Repair
    visit conservation_records_path
    click_link(conservation_record.title, match: :prefer_exact)
    expect(page).to have_button('Add In-House Repairs')
    click_button('Add In-House Repairs')
    select('Chuck Greenman', from: 'in_house_repair_record_performed_by_user_id')
    select('Soft slipcase', from: 'in_house_repair_record_repair_type', match: :first)
    fill_in('in_house_repair_record_other_note', with: 'Some Other note for the in-house repair')
    fill_in('in_house_repair_record_minutes_spent', with: '2')
    select('test', from: 'in_house_repair_record_staff_code_id', match: :first)
    click_button('Create In-House Repair Record')
    expect(page).to have_content('Soft slipcase performed by Chuck Greenman in 2 minutes. Other note: Some Other note for the in-house repair')

    # External Repair
    expect(page).to have_button('Add External Repair')
    click_button('Add External Repair')
    select('Amanda Buck', from: 'external_repair_record_performed_by_vendor_id', match: :first)
    select('Wash', from: 'external_repair_record_repair_type', match: :first)
    fill_in('external_repair_record_other_note', with: 'Some Other note for the external repair')
    click_button('Create External Repair Record')
    expect(page).to have_content('Wash performed by Amanda Buck. Other note: Some')

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
    click_on 'Treatment Proposal'
    expect(page).to have_select('treatment_report_treatment_proposal_housing_need_id', selected: 'Portfolio')
    expect(page).to have_select('treatment_report_treatment_proposal_housing_provided_id', selected: 'Portfolio')

    # Save Cost Return Information
    expect(page).to have_content('Cost and Return Information')
    fill_in 'cost_return_report_shipping_cost', with: 100
    fill_in 'cost_return_report_repair_estimate', with: 100
    fill_in 'cost_return_report_repair_cost', with: 100
    fill_in 'cost_return_report_invoice_sent_to_business_office', with: Time.zone.today.strftime('%Y-%m-%d')
    fill_in 'cost_return_report_note', with: 'Test cost & return info'
    click_button('Save Cost and Return Information')
    expect(page).to have_content('Test cost & return info')

    # Delete conservation record
    visit conservation_records_path
    accept_confirm do
      find("a[id='delete_conservation_record_#{conservation_record.id}']").click
    end
    expect(page).to have_content('Conservation record was successfully destroyed.')
  end
end

RSpec.describe 'Admin User Tests', type: :feature, versioning: true do
  let!(:staff_code) { create(:staff_code, code: 'test', points: 10) }
  let(:user) { create(:user, role: 'admin') }
  let(:conservation_record) { create(:conservation_record, title: 'Farewell to Arms') }
  let(:vocabulary) { create(:controlled_vocabulary, vocabulary: 'repair_type', active: true, favorite: true) }

  before do
    vocabulary
  end

  before do
    vocabulary
  end

  it 'allows User to login and show Conservation Records' do
    # Login
    log_in_as_user(user)

    # Create In_House Repair
    visit conservation_records_path
    click_link(conservation_record.title, match: :prefer_exact)
    expect(page).to have_button('Add In-House Repairs')
    click_button('Add In-House Repairs')
    select(user.display_name, from: 'in_house_repair_record_performed_by_user_id', match: :first)
    # get list of repair_types and check that favorite is first option
    repair_types = find('#in_house_repair_record_repair_type').all('option').collect(&:text)
    expect(repair_types[1..]).to start_with('key_string')
    select('Mend paper', from: 'in_house_repair_record_repair_type', match: :first)
    fill_in('in_house_repair_record_other_note', with: 'Some Other note for the in-house repair')
    fill_in('in_house_repair_record_minutes_spent', with: '2')
    select('test', from: 'in_house_repair_record_staff_code_id', match: :first)
    click_button('Create In-House Repair Record')
    expect(page).to have_content("Mend paper performed by #{user.display_name} in 2 minutes. Other note: Some Other note for the in-house repair")

    # Delete In-house repair
    accept_confirm do
      find("a[id='delete_in_house_repair_record_1']").click
    end
    expect(page).not_to have_content("Mend paper performed by #{user.display_name}")

    # Create External Repair
    expect(page).to have_button('Add External Repair')
    click_button('Add External Repair')
    select('Amanda Buck', from: 'external_repair_record_performed_by_vendor_id', match: :first)
    select('Wash', from: 'external_repair_record_repair_type', match: :first)
    fill_in('external_repair_record_other_note', with: 'Some Other note for the external repair')
    click_button('Create External Repair Record')
    expect(page).to have_content('Wash performed by Amanda Buck. Other note: Some Other note for the external repair')

    # Delete external repair
    accept_confirm do
      find("a[id='delete_external_repair_record_1']").click
    end
    expect(page).not_to have_content('Wash performed by Amanda Buck')

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

    # Download Conservation Worksheet
    verify_pdf_link_response('Download Conservation Worksheet')

    # Download Treatment Report
    verify_pdf_link_response('Download Treatment Report')

    # Download Abbreviated Treatment Report
    verify_pdf_link_response('Download Abbreviated Treatment Report')

    # Verify logged activity
    visit activity_index_path
    expect(page).to have_content("#{user.display_name} created the external repair record")
    expect(page).to have_content("#{user.display_name} deleted the external repair record")
    expect(page).to have_content("#{user.display_name} created the in house repair record")
    expect(page).to have_content("#{user.display_name} deleted the in house repair record")
    expect(page).to_not have_content("#{user.display_name} created the treatment report")
    expect(page).to have_content("#{user.display_name} updated the treatment report")
  end
end
