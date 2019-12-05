# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

describe 'User', type: :model do
  describe 'abilities' do
    subject(:ability) { Ability.new(user) }
    let(:user) { nil }

    context 'when is an admin' do
      let(:user) { build(:user, role: 'admin') }
      it { is_expected.to be_able_to(:manage, User.new) }
      it { is_expected.to be_able_to(:index, Admin) }
      it { is_expected.not_to be_able_to(:create, User) }
    end

    context 'when is a standard user' do
      let(:user) { build(:user, role: 'standard') }

      it { is_expected.not_to be_able_to(:index, User.new) }
      it { is_expected.not_to be_able_to(:create, User.new) }
      it { is_expected.not_to be_able_to(:read, User.new) }
      it { is_expected.not_to be_able_to(:update, User.new) }
      it { is_expected.not_to be_able_to(:destroy, User.new) }
      it { is_expected.not_to be_able_to(:index, Admin) }

      it { is_expected.to be_able_to(:index, ConservationRecord.new) }
      it { is_expected.to be_able_to(:read, ConservationRecord.new) }
      it { is_expected.to be_able_to(:create, ConservationRecord.new) }
      it { is_expected.to be_able_to(:update, ConservationRecord.new) }
      it { is_expected.to be_able_to(:destroy, ConservationRecord.new) }

      it { is_expected.to be_able_to(:index, ControlledVocabulary.new) }
      it { is_expected.to be_able_to(:create, ControlledVocabulary.new) }
      it { is_expected.to be_able_to(:read, ControlledVocabulary.new) }
      it { is_expected.to be_able_to(:update, ControlledVocabulary.new) }
      it { is_expected.to be_able_to(:destroy, ControlledVocabulary.new) }
    end

    context 'when is a read_only user' do
      let(:user) { build(:user, role: 'read_only') }

      it { is_expected.not_to be_able_to(:create, User.new) }
      it { is_expected.not_to be_able_to(:read, User.new) }
      it { is_expected.not_to be_able_to(:update, User.new) }
      it { is_expected.not_to be_able_to(:destroy, User.new) }
      it { is_expected.not_to be_able_to(:index, Admin) }

      it { is_expected.to be_able_to(:index, ConservationRecord.new) }
      it { is_expected.to be_able_to(:read, ConservationRecord.new) }
      it { is_expected.not_to be_able_to(:create, ConservationRecord.new) }
      it { is_expected.not_to be_able_to(:update, ConservationRecord.new) }
      it { is_expected.not_to be_able_to(:destroy, ConservationRecord.new) }

      it { is_expected.not_to be_able_to(:index, ControlledVocabulary.new) }
      it { is_expected.not_to be_able_to(:create, ControlledVocabulary.new) }
      it { is_expected.not_to be_able_to(:read, ControlledVocabulary.new) }
      it { is_expected.not_to be_able_to(:update, ControlledVocabulary.new) }
      it { is_expected.not_to be_able_to(:destroy, ControlledVocabulary.new) }
    end
  end
end
