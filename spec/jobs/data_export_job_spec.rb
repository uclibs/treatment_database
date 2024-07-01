# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DataExportJob, type: :job do
  include_context 'rake' # This job relies on rake tasks

  describe 'perform' do
    # Set up export job as a method so that it is freshly called each time.
    def export_job
      DataExportJob.perform_now
    end

    before do
      allow(Rake::Task).to receive(:task_defined?).and_return(task_defined)
    end

    context 'when rake task is already defined' do
      let(:task_defined) { true }

      it 'does not load rake tasks' do
        expect(Rails.application).not_to receive(:load_tasks)
        expect { export_job }.to change { Report.count }.by(1)
      end
    end

    context 'when rake task is not defined' do
      let(:task_defined) { false }

      it 'loads rake tasks' do
        expect(Rails.application).to receive(:load_tasks)
        expect { export_job }.to change { Report.count }.by(1)
      end
    end
  end
end
