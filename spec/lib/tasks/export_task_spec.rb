# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'export:all_data', type: :task do
  include_context 'rake'

  it 'is defined' do
    expect(Rake::Task['export:all_data']).to_not be_nil
  end

  it 'creates a new Report' do
    expect do
      Rake::Task['export:all_data'].invoke
    end.to change(Report, :count).by(1)
  end
end
