# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }
  let(:user) { nil }

  # Define a hash mapping roles to their abilities
  ability_map = {
    'admin' => {
      User => %i[index read create update],
      ConservationRecord => [:manage],
      ControlledVocabulary => [:manage],
      ExternalRepairRecord => [:manage],
      InHouseRepairRecord => [:manage],
      StaffCode => %i[index read create update],
      CostReturnReport => [:manage],
      ConTechRecord => [:manage],
      Report => [:manage],
      :activity => [:manage]
    },
    'standard' => {
      User => %i[read update],
      ConservationRecord => %i[index read create update destroy],
      ControlledVocabulary => [],
      ExternalRepairRecord => %i[index read create update destroy],
      InHouseRepairRecord => %i[index read create update destroy],
      StaffCode => [],
      CostReturnReport => %i[index read create update destroy],
      ConTechRecord => %i[index read create update destroy],
      Report => [],
      :activity => []
    },
    'read_only' => {
      User => %i[read update],
      ConservationRecord => %i[index read],
      ControlledVocabulary => [],
      ExternalRepairRecord => %i[index read],
      InHouseRepairRecord => %i[index read],
      StaffCode => [],
      CostReturnReport => %i[index read],
      ConTechRecord => %i[index read],
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
  actions_to_test = %i[index create read update destroy]

  ability_map.each do |role, permissions|
    context "when user is a #{role}" do
      let(:user) { build(:user, role:) }

      # Iterate over each model and its permissions
      permissions.each do |model, allowed_actions|
        actions_to_test.each do |action|
          if allowed_actions.include?(:manage) || allowed_actions.include?(action)
            it { is_expected.to be_able_to(action, model == :activity ? model : model.new) }
          else
            it { is_expected.not_to be_able_to(action, model == :activity ? model : model.new) }
          end
        end
      end
    end
  end
end
