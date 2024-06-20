# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DataExportJob, type: :job do
  include_context 'rake' # This job relies on rake tasks

  let(:data_export) { DataExportJob.perform_now }
  it 'creates a report object' do
    expect { data_export }.to change { Report.count }.by 1
  end
end
