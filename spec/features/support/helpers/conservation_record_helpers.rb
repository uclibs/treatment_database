def add_in_house_repair(conservation_record)
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
end