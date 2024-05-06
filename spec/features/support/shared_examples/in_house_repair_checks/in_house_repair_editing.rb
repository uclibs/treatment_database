# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'edits in-house repairs' do
  let(:conservation_record) { create(:conservation_record) }

  before do
    conservation_record
  end

  it 'edits an in-house repair' do
    # Currently there is no funtionality to edit an in-house repair.
  end
end
