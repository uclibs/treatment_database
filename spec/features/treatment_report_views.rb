require 'rails_helper'

RSpec.describe 'TreatmentReport views', type: :feature do
  it 'displays the rich text content correctly' do
    # Assuming you have a factory for TreatmentReport
    treatment_report = create(:treatment_report, abbreviated_treatment_report: 'This is <strong>bold</strong> text.')

    visit treatment_report_path(treatment_report)

    # Use Capybara to check for the presence of the bold text
    # This depends on how the rich text content is wrapped in your HTML
    expect(page).to have_css('strong', text: 'bold')
  end
end
