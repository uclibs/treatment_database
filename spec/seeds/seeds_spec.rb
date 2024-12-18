# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Database Seeding', type: :feature do
  # Use truncation to ensure a fully clean slate before each seeding test
  before(:each) do
    DatabaseCleaner.clean_with(:truncation)
  end

  after(:each) do
    DatabaseCleaner.clean # Clean up after each test
  end

  # Helper function to manage ENV variables
  def with_seedable(value)
    original_seedable = ENV.fetch('SEEDABLE', nil)
    ENV['SEEDABLE'] = value
    yield
  ensure
    ENV['SEEDABLE'] = original_seedable # Ensure ENV is reset to original value after each test
  end

  context 'when SEEDABLE is true' do
    before(:each) do
      with_seedable('true') do
        Rails.application.load_seed # Explicitly load seeds
      end
    end

    it 'seeds the user data' do
      expect(User.count).to be > 0
      expect(User.find_by(username: 'johngreen')).not_to be_nil
      expect(User.find_by(username: 'jkrowling')).not_to be_nil
      expect(User.find_by(username: 'chuck')).not_to be_nil
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
    before(:each) do
      with_seedable('false') do
        Rails.application.load_seed # Explicitly load seeds
      end
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
    before(:each) do
      with_seedable(nil) do
        Rails.application.load_seed # Explicitly load seeds
      end
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
