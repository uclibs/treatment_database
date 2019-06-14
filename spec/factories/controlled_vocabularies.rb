FactoryBot.define do
  factory :controlled_vocabulary do
    vocabulary { "MyString" }
    key { "MyString" }
    active { false }
  end
end
