class Ability
  include CanCan::Ability

  def initialize(user)
    if user.is_admin
      can :manage , :all
    else
      can :read , :user
      can :update , :user
    end
  end
end
