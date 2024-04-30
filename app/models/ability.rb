# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    define_alias_actions
    assign_permissions_for(user)
  end

  private

  def define_alias_actions
    alias_action :create, :read, :update, :destroy, to: :crud
    alias_action :treatment_report, :abbreviated_treatment_report, :conservation_worksheet, to: :view_pdfs
  end

  def assign_permissions_for(user)
    case user.role
    when 'admin'
      admin_permissions
    when 'standard'
      standard_permissions(user)
    else
      read_only_permissions(user)
    end
  end

  def admin_permissions
    can :manage, :all
    cannot :destroy, StaffCode
  end

  def standard_permissions(user)
    can :view_pdfs, ConservationRecord
    can :crud, [ConservationRecord, ExternalRepairRecord, InHouseRepairRecord, ConTechRecord, CostReturnReport]
    can %i[read update], User, id: user.id
    cannot :index, User
  end

  def read_only_permissions(user)
    can :view_pdfs, ConservationRecord
    can :read, ConservationRecord
    can :index, ConservationRecord
    can %i[read update], User, id: user.id
    cannot :index, User
  end
end
