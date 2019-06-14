require 'rails_helper'

RSpec.describe "conservation_records/show", type: :view do
  before(:each) do
    @conservation_record = assign(:conservation_record, ConservationRecord.create!(
      :department => "Department",
      :title => "Title",
      :author => "Author",
      :imprint => "Imprint",
      :call_number => "Call Number",
      :item_record_number => "Item Record Number",
      :digitization => false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Department/)
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/Author/)
    expect(rendered).to match(/Imprint/)
    expect(rendered).to match(/Call Number/)
    expect(rendered).to match(/Item Record Number/)
    expect(rendered).to match(/false/)
  end
end
