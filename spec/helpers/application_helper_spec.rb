# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe 'controlled_vocabulary_lookup' do
    let(:controlled_vocab) { create :controlled_vocabulary }

    it 'returns a controlled vocab object' do
      result = helper.controlled_vocabulary_lookup(controlled_vocab.id)
      expect(result).to eq(controlled_vocab.key)
    end

    it 'returns id missing string if vocab id is nil' do
      result = helper.controlled_vocabulary_lookup(nil)
      expect(result).to eq('ID Missing')
    end
  end

  describe 'user_display_name' do
    let(:user) { create :user }

    it 'returns an existing user\'s display name' do
      result = helper.user_display_name(user.id)
      expect(result).to eq(user.display_name)
    end

    it 'rescues and returns user not found string for non-existing user' do
      result = helper.user_display_name(9999)
      expect(result).to eq('User not found (ID: 9999)')
    end
  end

  describe 'webpack_image_path' do
    it 'returns the correct image path from the manifest' do
      manifest = { 'delete.png' => 'delete-12345.png' }
      allow(File).to receive(:read).and_return(manifest.to_json)
      allow(Rails).to receive(:public_path).and_return(Pathname.new('public'))

      result = helper.webpack_image_path('delete.png')
      expect(result).to eq('/build/delete-12345.png')
    end
  end

  describe 'webpack_stylesheet_path' do
    it 'returns the correct stylesheet path in development' do
      manifest = { 'application.css' => 'application-12345.css' }
      allow(File).to receive(:read).and_return(manifest.to_json)
      allow(Rails).to receive(:public_path).and_return(Pathname.new('public'))
      allow(Rails.env).to receive(:production?).and_return(false)

      result = helper.webpack_stylesheet_path
      expect(result).to eq('/build/application-12345.css')
    end

    it 'returns the correct stylesheet path in production' do
      manifest = { 'application.css' => 'application-12345.css' }
      allow(File).to receive(:read).and_return(manifest.to_json)
      allow(Rails).to receive(:public_path).and_return(Pathname.new('public'))
      allow(Rails.env).to receive(:production?).and_return(true)

      result = helper.webpack_stylesheet_path
      expect(result).to eq('/treatment_database/build/application-12345.css')
    end
  end

  describe 'webpack_javascript_path' do
    it 'returns the correct javascript path in development' do
      manifest = { 'application.js' => 'application-12345.js' }
      allow(File).to receive(:read).and_return(manifest.to_json)
      allow(Rails).to receive(:public_path).and_return(Pathname.new('public'))
      allow(Rails.env).to receive(:production?).and_return(false)

      result = helper.webpack_javascript_path
      expect(result).to eq('/build/application-12345.js')
    end

    it 'returns the correct javascript path in production' do
      manifest = { 'application.js' => 'application-12345.js' }
      allow(File).to receive(:read).and_return(manifest.to_json)
      allow(Rails).to receive(:public_path).and_return(Pathname.new('public'))
      allow(Rails.env).to receive(:production?).and_return(true)

      result = helper.webpack_javascript_path
      expect(result).to eq('/treatment_database/build/application-12345.js')
    end
  end
end
