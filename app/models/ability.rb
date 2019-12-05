# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user) # rubocop:disable Metrics/MethodLength
    user ||= User.new # guest user (not logged in)

    alias_action :create, :read, :update, :destroy, to: :crud

    if user.role == 'admin'
      can :manage, :all
      can :assign_roles, User
      cannot :create, User
    elsif user.role == 'standard'
      can :crud, [ConservationRecord, ControlledVocabulary, ExternalRepairRecord, InHouseRepairRecord]
    elsif user.role == 'read_only'
      can :read, [ConservationRecord, ExternalRepairRecord, InHouseRepairRecord]
    end
  end
end
