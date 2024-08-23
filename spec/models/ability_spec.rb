# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }
  let(:user) { nil }

  # Define a hash mapping roles to their abilities
  ability_map = {
    'admin' => {
      User => [:index, :read, :create, :update],
      ConservationRecord => [:manage],
      ControlledVocabulary => [:manage],
      ExternalRepairRecord => [:manage],
      InHouseRepairRecord => [:manage],
      StaffCode => [:index, :read, :create, :update],
      CostReturnReport => [:manage],
      ConTechRecord => [:manage],
      Report => [:manage],
      :activity => [:manage]
    },
    'standard' => {
      User => [:read, :update],
      ConservationRecord => [:index, :read, :create, :update, :destroy],
      ControlledVocabulary => [],
      ExternalRepairRecord => [:index, :read, :create, :update, :destroy],
      InHouseRepairRecord => [:index, :read, :create, :update, :destroy],
      StaffCode => [],
      CostReturnReport => [:index, :read, :create, :update, :destroy],
      ConTechRecord => [:index, :read, :create, :update, :destroy],
      Report => [],
      :activity => []
    },
    'read_only' => {
      User => [:read, :update],
      ConservationRecord => [:index, :read],
      ControlledVocabulary => [],
      ExternalRepairRecord => [],
      InHouseRepairRecord => [],
      StaffCode => [],
      CostReturnReport => [],
      ConTechRecord => [],
      Report => [],
      :activity => []
    },
    'invalid_role' => {
      User => [],
      ConservationRecord => [],
      ControlledVocabulary => [],
      ExternalRepairRecord => [],
      InHouseRepairRecord => [],
      StaffCode => [],
      CostReturnReport => [],
      ConTechRecord => [],
      Report => [],
      :activity => []
    }
  }

  # Full list of actions to test
  actions_to_test = [:index, :create, :read, :update, :destroy]

  ability_map.each do |role, permissions|
    context "when user is a #{role}" do
      let(:user) { build(:user, role: role) }

      # Iterate over each model and its permissions
      permissions.each do |model, allowed_actions|
        actions_to_test.each do |action|
          if allowed_actions.include?(:manage)
            it { is_expected.to be_able_to(action, model == :activity ? model : model.new) }
          else
            if allowed_actions.include?(action)
              it { is_expected.to be_able_to(action, model == :activity ? model : model.new) }
            else
              it { is_expected.not_to be_able_to(action, model == :activity ? model : model.new) }
            end
          end
        end
      end
    end
  end
end
