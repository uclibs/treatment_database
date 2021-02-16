require 'rails_helper'

RSpec.describe 'Admin User Tests', type: :feature do

  let(:user) { create(:user, role: 'admin') }
  let(:conservation_record) { create(:conservation_record, department: 'ARB Library') }
  let(:vocabulary) { create(:controlled_vocabulary)}
  let(:in_house_repair) { create(:in_house_repair_record) }
  it 'allows User to login and show Conservation Records' do

    #Login

    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'notapassword'
    click_button 'Log in'
    expect(page).to have_content('Signed in successfully')
    
    #Show Conservation Records

    click_on 'Conservation Records'
    expect(page).to have_content('Conservation Records')
    expect(page).to have_link('Destroy')
    expect(page).to have_link('Show')
    click_link('Show',match: :prefer_exact)
    expect(page).to have_content('Farewell to Arms')
 

    #Edit Conservation Record
  
    visit conservation_records_path
    click_link('Edit', match: :prefer_exact)
    expect(page).to have_content('Editing Conservation Record')
   
    #Edit Users   
    
    visit conservation_records_path
    click_on 'Users'
    expect(page).to have_content('Users')
    click_link('Edit', match: :prefer_exact)
    expect(page).to have_content('Admin Users Edit')
    fill_in 'Display name', with: 'Haritha Vytla'
    fill_in 'Email', with: 'vytlasa@mail.uc.edu'
    select('Admin', :from => 'Role')
    click_on 'Update User'
    expect(page).to have_content('Haritha Vytla') 
    
    #View Activity

    visit conservation_records_path
    click_link('Activity')
    expect(page).to have_content('Recent Activity')
    expect(page).to have_content('updated the user: Haritha Vytla')
    
    #Add Vocabulary

    visit conservation_records_path
    click_link('Vocabularies')
    expect(page).to have_content('Controlled Vocabularies')
    click_link('New Controlled Vocabulary')
    expect(page).to have_content('New Controlled Vocabulary')
    fill_in 'Vocabulary', with: 'vocabulary_string'
    fill_in 'Key', with: 'key_string'
    click_button 'Create Controlled vocabulary'
    expect(page).to have_content('Controlled vocabulary was successfully created')
    
    #Add New Conservation Record     

    visit conservation_records_path
    click_on 'Add Conservation Record'
    expect(page).to have_content('New Conservation Record')
    select('ARB Library', :from => 'Department', match: :first)
    fill_in 'Title', with: conservation_record.title
    fill_in 'Author', with: conservation_record.author
    fill_in 'Imprint', with: conservation_record.imprint
    fill_in 'Call number', with: conservation_record.call_number
    fill_in 'Item record number', with: conservation_record.item_record_number
    click_on 'Create Conservation record'
    expect(page).to have_content('Conservation record was successfully created')
    expect(page).to have_content(conservation_record.title)

    #Edit the existing Conservation Record
    
    click_on 'Edit Conservation Record'
    expect(page).to have_content('Editing Conservation Record')

    #In_House Repair
    
   #visit conservation_records_path
  #  click_link('Show', match: :prefer_exact)
  #  expect(page).to have_button('Add In-House Repairs')
  #  click_button('Add In-House Repairs')
  #  select('Haritha Vytla', :from => 'Repaired By')
  #  select('Wash', :from => 'Repair Type')
  #  click_button('Create In-House Repair Record')
  #  expect(page).to have_content('Wash performed by Haritha Vytla')

   
    #Save Treatment Report

    #visit conservation_records_path
    #click_link('Show', match: :prefer_exact)
    #expect(page).to have_content('Treatment Report')
    #fill_in 'General Remarks', with: nil
    #fill_in 'Binding', with: nil
    #fill_in 'Textblock', with: nil
    #fill_in 'Primary Support', with: nil
    #fill_in 'Medium', with: nil
    #fill_in Attachments|Inserts, with: nil
    #fill_in Housing, with: nil
    #click_button('Save Treatment Report')
    #expect(page).to have_content('Treatment Record updated successfully!')

  end 
 
end
