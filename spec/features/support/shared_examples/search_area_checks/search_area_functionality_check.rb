# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'Navbar Search Behavior' do
  let(:cons_record) { create_conservation_record }

  before do
    visit conservation_records_path
    cons_record
    within('nav.navbar') do
      @navbar = page
    end
  end

  it 'verifies search form visibility' do
    expect(@navbar).to have_selector('form[action="/search"]')
    expect(@navbar).to have_field('search', type: 'text')
    expect(@navbar).to have_button('Search', disabled: false)
    expect(@navbar).to have_link('(?)', href: '/search/help')
  end

  it 'finds the record by title' do
    perform_search(cons_record.title)
    expect(@navbar).to have_content('Item Detail')
    expect(@navbar).to have_content(cons_record.title)
  end

  it 'finds the record by record number' do
    perform_search(cons_record.item_record_number)
    expect(@navbar).to have_content('Item Detail')
    expect(@navbar).to have_content(cons_record.title)
  end

  def perform_search(query)
    @navbar.fill_in 'Search', with: query
    @navbar.click_button 'Search'
  end

  def create_conservation_record
    FactoryBot.create(:conservation_record, title: 'The Three Bears', item_record_number: 'i123456')
  end
end
