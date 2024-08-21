# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    alias_action :create, :read, :update, :destroy, to: :crud
    alias_action :treatment_report, :abbreviated_treatment_report, :conservation_worksheet, to: :view_pdfs

    case user.role
    when 'admin'
      can :manage, :all
      cannot :destroy, StaffCode
      cannot :destroy, User
    when 'standard'
      can :view_pdfs, ConservationRecord
      can :crud, [ConservationRecord, ExternalRepairRecord, InHouseRepairRecord, ConTechRecord, CostReturnReport]
      can :index, ConservationRecord
    when 'read_only'
      can :view_pdfs, ConservationRecord
      can :read, ConservationRecord
      can :index, ConservationRecord
    else
      cannot :manage, :all
    end
  end
end
