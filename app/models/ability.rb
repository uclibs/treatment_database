# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
    user ||= User.new # guest user (not logged in)

    alias_action :create, :read, :update, :destroy, to: :crud
    alias_action :treatment_report, :abbreviated_treatment_report, :conservation_worksheet, to: :view_pdfs

    case user.role
    when 'admin'
      can :manage, :all
      can :assign_roles, User
      can :create, User
      can :crud, [ControlledVocabulary]
    when 'standard'
      can :view_pdfs, [ConservationRecord]
      can :crud, [ConservationRecord, ExternalRepairRecord, InHouseRepairRecord]
    when 'read_only'
      can :read, [ConservationRecord, ExternalRepairRecord, InHouseRepairRecord]
    end
  end
end
