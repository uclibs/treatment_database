# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sample feature test with JS', type: :feature, js: true do
  it 'uses the truncation database cleaner strategy' do
    cleaner = DatabaseCleaner[:active_record]
    expect(cleaner.strategy).to be_a(DatabaseCleaner::ActiveRecord::Truncation)
  end
end

RSpec.describe 'Sample feature test without JS', type: :feature do
  it 'uses the transaction database cleaner strategy' do
    cleaner = DatabaseCleaner[:active_record]
    expect(cleaner.strategy).to be_a(DatabaseCleaner::ActiveRecord::Transaction)
  end
end

RSpec.describe 'Sample controller test', type: :controller do
  it 'uses the transaction database cleaner strategy' do
    cleaner = DatabaseCleaner[:active_record]
    expect(cleaner.strategy).to be_a(DatabaseCleaner::ActiveRecord::Transaction)
  end
end
