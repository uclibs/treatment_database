# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Report, type: :model do
  let(:report) { create(:report) }
  let(:csv_file) { fixture_file_upload(Rails.root.join('spec/fixtures/files/sample.csv'), 'text/csv') }

  describe 'attachments' do
    it 'can have a CSV file attached' do
      report.csv_file.attach(csv_file)
      expect(report.csv_file).to be_attached
    end

    it 'has the correct content type' do
      report.csv_file.attach(csv_file)
      expect(report.csv_file.blob.content_type).to eq('text/csv')
    end

    it 'can remove an attached CSV file' do
      report.csv_file.attach(csv_file)
      report.csv_file.purge
      expect(report.csv_file).not_to be_attached
    end
  end
end
