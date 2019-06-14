FactoryBot.define do
  factory :conservation_record do
    date_recieved_in_preservation_services { "2019-06-11" }
    department { "MyString" }
    title { "MyString" }
    author { "MyString" }
    imprint { "MyString" }
    call_number { "MyString" }
    item_record_number { "MyString" }
    digitization { false }
  end
end
