# frozen_string_literal: true

require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the ActivityHelper. For example:
#
# describe ApplicationHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe ApplicationHelper, type: :helper do
  let(:controlled_vocab) { create :controlled_vocabulary }
  describe 'controlled_vocabulary_lookup' do
    it 'returns a controlled vocab object' do
      result = helper.controlled_vocabulary_lookup(controlled_vocab.id)
      expect(result).to eq(controlled_vocab.key)
    end

    it 'returns id missing string if vocab id is nil' do
      result = helper.controlled_vocabulary_lookup(nil)
      expect(result).to eq('ID Missing')
    end
  end
end
