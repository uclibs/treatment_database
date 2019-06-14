require 'rails_helper'

RSpec.describe "conservation_records/index", type: :view do
  before(:each) do
    assign(:conservation_records, [
      ConservationRecord.create!(
        :department => "Department",
        :title => "Title",
        :author => "Author",
        :imprint => "Imprint",
        :call_number => "Call Number",
        :item_record_number => "Item Record Number",
        :digitization => false
      ),
      ConservationRecord.create!(
        :department => "Department",
        :title => "Title",
        :author => "Author",
        :imprint => "Imprint",
        :call_number => "Call Number",
        :item_record_number => "Item Record Number",
        :digitization => false
      )
    ])
  end

  it "renders a list of conservation_records" do
    render
    assert_select "tr>td", :text => "Department".to_s, :count => 2
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "Author".to_s, :count => 2
    assert_select "tr>td", :text => "Imprint".to_s, :count => 2
    assert_select "tr>td", :text => "Call Number".to_s, :count => 2
    assert_select "tr>td", :text => "Item Record Number".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
