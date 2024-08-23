# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    alias_action :create, :read, :update, :destroy, to: :crud
    alias_action :treatment_report, :abbreviated_treatment_report, :conservation_worksheet, to: :view_pdfs

    case user.role
    when 'admin'
      admin_permissions
    when 'standard'
      standard_permissions(user)
    when 'read_only'
      read_only_permissions(user)
    else
      guest_permissions
    end
  end

  private

  def admin_permissions
    can :manage, :all
    cannot :destroy, StaffCode
    cannot :destroy, User
  end

  def standard_permissions(user)
    can :view_pdfs, ConservationRecord
    can :crud, [ConservationRecord, ExternalRepairRecord, InHouseRepairRecord, ConTechRecord, CostReturnReport]
    can :index, ConservationRecord
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

  def guest_permissions
    cannot :manage, :all
  end
end
