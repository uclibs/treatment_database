# frozen_string_literal: true

require 'rails_helper'

describe 'Database Connection' do
  it 'should connect to the database successfully' do
    expect { ActiveRecord::Base.connection }.not_to raise_error
  end
end
