# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Database Seeding' do
  before do
    # Stub the SEEDABLE environment variable as needed for each test
    allow(ENV).to receive(:[]).and_call_original
  end

  context 'when SEEDABLE is true' do
    before do
      DatabaseCleaner.clean # Ensure the database is clean before loading seeds
      allow(ENV).to receive(:[]).with('SEEDABLE').and_return('true')
      Rails.application.load_seed # Explicitly load seeds to simulate the environment
    end

    it 'seeds the user data' do
      expect(User.count).to be > 0
      expect(User.find_by(email: 'johngreen@example.com')).not_to be_nil
      expect(User.find_by(email: 'jkrowling@example.com')).not_to be_nil
      expect(User.find_by(email: 'chuck@chuck.codes')).not_to be_nil
    end

    it 'seeds the conservation record data' do
      expect(ConservationRecord.count).to be > 0
    end

    it 'seeds the controlled vocabulary data' do
      expect(ControlledVocabulary.count).to be > 0
    end

    it 'seeds the staff code data' do
      expect(StaffCode.count).to be > 0
    end
  end

  context 'when SEEDABLE is false' do
    before do
      DatabaseCleaner.clean # Ensure the database is clean before loading seeds
      allow(ENV).to receive(:[]).with('SEEDABLE').and_return('false')
      Rails.application.load_seed # Explicitly load seeds to simulate the environment
    end

    it 'does not seed the user data' do
      expect(User.count).to eq(0)
    end

    it 'does not seed the conservation record data' do
      expect(ConservationRecord.count).to eq(0)
    end

    it 'seeds the controlled vocabulary data' do
      expect(ControlledVocabulary.count).to be > 0
    end

    it 'seeds the staff code data' do
      expect(StaffCode.count).to be > 0
    end
  end

  context 'when SEEDABLE is not set' do
    before do
      DatabaseCleaner.clean # Ensure the database is clean before loading seeds
      allow(ENV).to receive(:[]).with('SEEDABLE').and_return(nil)
      Rails.application.load_seed # Explicitly load seeds to simulate the environment
    end

    it 'does not seed the user data' do
      expect(User.count).to eq(0)
    end

    it 'does not seed the conservation record data' do
      expect(ConservationRecord.count).to eq(0)
    end

    it 'seeds the controlled vocabulary data' do
      expect(ControlledVocabulary.count).to be > 0
    end

    it 'seeds the staff code data' do
      expect(StaffCode.count).to be > 0
    end

  end
end
