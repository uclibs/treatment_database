# frozen_string_literal: true

RSpec.shared_examples 'can edit conservation records' do
  let(:conservation_record) { create(:conservation_record, title: 'Farewell to Arms', department: 2) }

  before do
    conservation_record
  end

  it 'can edit conservation records' do
    visit conservation_records_path
    click_link(conservation_record.title, match: :prefer_exact)
    expect(page).to have_content('Item Detail')
    expect(page).to have_link('Edit Conservation Record', class: 'btn btn-primary')
    click_link 'Edit Conservation Record'
    fill_in 'Imprint', with: 'University of Cincinnati Press'
    click_on 'Update Conservation record'
    expect(page).to have_content('Conservation record was successfully updated')
    expect(page).to have_content('University of Cincinnati Press')
  end
end

RSpec.shared_examples 'cannot edit conservation records' do
  let(:conservation_record) { create(:conservation_record, title: 'Farewell to Arms', department: 2) }

  before do
    conservation_record
  end

  it 'does not allow editing conservation records' do
    visit conservation_records_path
    click_link(conservation_record.title, match: :prefer_exact)
    expect(page).to have_content('Item Detail')
    expect(page).to_not have_link('Edit Conservation Record', class: 'btn btn-primary')
  end
end
