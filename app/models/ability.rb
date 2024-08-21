# frozen_string_literal: true

# The Ability class defines user permissions using the CanCanCan gem based on user roles.
# It includes permission sets for admin, standard, and read_only users, allowing CRUD actions
# and access to specific models such as ConservationRecord, User, and other related records.
# Custom actions like viewing PDFs and managing specific records are also defined for each role.

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
    when 'standard'
      can :view_pdfs, ConservationRecord
      can :crud, [ConservationRecord, ExternalRepairRecord, InHouseRepairRecord, ConTechRecord, CostReturnReport]
      can :index, ConservationRecord
      # Allow standard users to read and update their own user account, but not index other users
      can %i[read update], User, id: user.id
      cannot :index, User
    when 'read_only'
      can :view_pdfs, ConservationRecord
      can :read, ConservationRecord
      can :index, ConservationRecord
      # Allow read_only users to read and update their own user account, but not index other users
      can %i[read update], User, id: user.id
      cannot :index, User
    else
      cannot :manage, :all
    end
  end
end
