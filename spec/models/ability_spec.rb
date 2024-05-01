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
      it { is_expected.to be_able_to(:manage, ConservationRecord.new) }
      it { is_expected.to be_able_to(:manage, ControlledVocabulary.new) }
      it { is_expected.to be_able_to(:manage, ExternalRepairRecord.new) }
      it { is_expected.to be_able_to(:manage, InHouseRepairRecord.new) }
      it { is_expected.to be_able_to(:manage, StaffCode.new) }
      it { is_expected.to be_able_to(:manage, CostReturnReport.new) }
      it { is_expected.to be_able_to(:manage, ConTechRecord.new) }
      it { is_expected.to be_able_to(:manage, Report.new) }
      it { is_expected.to be_able_to(:manage, :activity) }
    end

    context 'when is a standard user' do
      let(:user) { build(:user, role: 'standard') }

      it { is_expected.not_to be_able_to(:index, User.new) }
      it { is_expected.not_to be_able_to(:create, User.new) }
      it { is_expected.not_to be_able_to(:read, User.new) }
      it { is_expected.not_to be_able_to(:update, User.new) }
      it { is_expected.not_to be_able_to(:destroy, User.new) }

      it { is_expected.to be_able_to(:index, ConservationRecord.new) }
      it { is_expected.to be_able_to(:read, ConservationRecord.new) }
      it { is_expected.to be_able_to(:create, ConservationRecord.new) }
      it { is_expected.to be_able_to(:update, ConservationRecord.new) }
      it { is_expected.to be_able_to(:destroy, ConservationRecord.new) }

      it { is_expected.not_to be_able_to(:index, ControlledVocabulary.new) }
      it { is_expected.not_to be_able_to(:create, ControlledVocabulary.new) }
      it { is_expected.not_to be_able_to(:read, ControlledVocabulary.new) }
      it { is_expected.not_to be_able_to(:update, ControlledVocabulary.new) }
      it { is_expected.not_to be_able_to(:destroy, ControlledVocabulary.new) }

      it { is_expected.to be_able_to(:index, ExternalRepairRecord.new) }
      it { is_expected.to be_able_to(:create, ExternalRepairRecord.new) }
      it { is_expected.to be_able_to(:read, ExternalRepairRecord.new) }
      it { is_expected.to be_able_to(:update, ExternalRepairRecord.new) }
      it { is_expected.to be_able_to(:destroy, ExternalRepairRecord.new) }

      it { is_expected.to be_able_to(:index, InHouseRepairRecord.new) }
      it { is_expected.to be_able_to(:create, InHouseRepairRecord.new) }
      it { is_expected.to be_able_to(:read, InHouseRepairRecord.new) }
      it { is_expected.to be_able_to(:update, InHouseRepairRecord.new) }
      it { is_expected.to be_able_to(:destroy, InHouseRepairRecord.new) }

      it { is_expected.not_to be_able_to(:index, StaffCode.new) }
      it { is_expected.not_to be_able_to(:create, StaffCode.new) }
      it { is_expected.not_to be_able_to(:read, StaffCode.new) }
      it { is_expected.not_to be_able_to(:update, StaffCode.new) }
      it { is_expected.not_to be_able_to(:destroy, StaffCode.new) }

      it { is_expected.to be_able_to(:index, CostReturnReport.new) }
      it { is_expected.to be_able_to(:create, CostReturnReport.new) }
      it { is_expected.to be_able_to(:read, CostReturnReport.new) }
      it { is_expected.to be_able_to(:update, CostReturnReport.new) }
      it { is_expected.to be_able_to(:destroy, CostReturnReport.new) }

      it { is_expected.to be_able_to(:index, ConTechRecord.new) }
      it { is_expected.to be_able_to(:create, ConTechRecord.new) }
      it { is_expected.to be_able_to(:read, ConTechRecord.new) }
      it { is_expected.to be_able_to(:update, ConTechRecord.new) }
      it { is_expected.to be_able_to(:destroy, ConTechRecord.new) }

      it { is_expected.not_to be_able_to(:index, Report.new) }
      it { is_expected.not_to be_able_to(:create, Report.new) }
      it { is_expected.not_to be_able_to(:read, Report.new) }
      it { is_expected.not_to be_able_to(:destroy, Report.new) }

      it { is_expected.not_to be_able_to(:index, :activity) }
      it { is_expected.not_to be_able_to(:show, :activity) }
    end

    context 'when is a read_only user' do
      let(:user) { build(:user, role: 'read_only') }

      it { is_expected.not_to be_able_to(:index, User.new) }
      it { is_expected.not_to be_able_to(:create, User.new) }
      it { is_expected.not_to be_able_to(:read, User.new) }
      it { is_expected.not_to be_able_to(:update, User.new) }
      it { is_expected.not_to be_able_to(:destroy, User.new) }

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

      it { is_expected.not_to be_able_to(:index, ExternalRepairRecord.new) }
      it { is_expected.not_to be_able_to(:create, ExternalRepairRecord.new) }
      it { is_expected.not_to be_able_to(:read, ExternalRepairRecord.new) }
      it { is_expected.not_to be_able_to(:update, ExternalRepairRecord.new) }
      it { is_expected.not_to be_able_to(:destroy, ExternalRepairRecord.new) }

      it { is_expected.not_to be_able_to(:index, InHouseRepairRecord.new) }
      it { is_expected.not_to be_able_to(:create, InHouseRepairRecord.new) }
      it { is_expected.not_to be_able_to(:read, InHouseRepairRecord.new) }
      it { is_expected.not_to be_able_to(:update, InHouseRepairRecord.new) }
      it { is_expected.not_to be_able_to(:destroy, InHouseRepairRecord.new) }

      it { is_expected.not_to be_able_to(:index, StaffCode.new) }
      it { is_expected.not_to be_able_to(:create, StaffCode.new) }
      it { is_expected.not_to be_able_to(:read, StaffCode.new) }
      it { is_expected.not_to be_able_to(:update, StaffCode.new) }
      it { is_expected.not_to be_able_to(:destroy, StaffCode.new) }

      it { is_expected.not_to be_able_to(:index, CostReturnReport.new) }
      it { is_expected.not_to be_able_to(:create, CostReturnReport.new) }
      it { is_expected.not_to be_able_to(:read, CostReturnReport.new) }
      it { is_expected.not_to be_able_to(:update, CostReturnReport.new) }
      it { is_expected.not_to be_able_to(:destroy, CostReturnReport.new) }

      it { is_expected.not_to be_able_to(:index, ConTechRecord.new) }
      it { is_expected.not_to be_able_to(:create, ConTechRecord.new) }
      it { is_expected.not_to be_able_to(:read, ConTechRecord.new) }
      it { is_expected.not_to be_able_to(:update, ConTechRecord.new) }
      it { is_expected.not_to be_able_to(:destroy, ConTechRecord.new) }

      it { is_expected.not_to be_able_to(:index, Report.new) }
      it { is_expected.not_to be_able_to(:create, Report.new) }
      it { is_expected.not_to be_able_to(:read, Report.new) }
      it { is_expected.not_to be_able_to(:update, Report.new) }
      it { is_expected.not_to be_able_to(:destroy, Report.new) }

      it { is_expected.not_to be_able_to(:index, :activity) }
      it { is_expected.not_to be_able_to(:show, :activity) }
    end
  end
end
