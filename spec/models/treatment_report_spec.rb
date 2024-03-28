# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TreatmentReport, type: :model do
  it 'is tracked by paper trail' do
    is_expected.to be_versioned
  end

  it 'correctly saves and retrieves rich text content, preserving formatting' do
    treatment_report = create(:treatment_report)

    formatted_text = '<em>Hello</em>, <strong>world</strong>!'
    treatment_report.abbreviated_treatment_report = formatted_text
    treatment_report.save!

    reloaded_text = treatment_report.reload.abbreviated_treatment_report

    expect(reloaded_text.body.to_s).to include('<em>Hello</em>, <strong>world</strong>!')
    expect(reloaded_text.to_plain_text).to eq('Hello, world!')
  end
end
