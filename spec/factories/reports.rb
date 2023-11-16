# frozen_string_literal: true

FactoryBot.define do
  factory :report do
    after(:build) do |post|
      post.csv_file.attach(
        io: Rails.root.join('test/fixture_files/test.csv').open,
        filename: 'test.csv'
      )
    end
  end
end
