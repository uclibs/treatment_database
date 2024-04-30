# frozen_string_literal: true

FactoryBot.define do
  factory :report do
    after(:build) do |post|
      post.csv_file.attach(
        io: Rails.root.join('spec/fixtures/files/sample.csv').open,
        filename: 'sample.csv'
      )
    end
  end
end
