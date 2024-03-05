# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TreatmentReport, type: :model do
  it 'is tracked by paper trail' do
    is_expected.to be_versioned
  end
end
