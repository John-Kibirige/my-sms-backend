class Ability
  include CanCan::Ability

  def initialize(user)
    if user != nil
      if user.role == 'admin'
        can :manage, :all
      elsif user.role == 'student'
        can :read, :all
      elsif user.role == 'teacher'
        can :read, :all
        can :manage, [Exam, Result]
      elsif user.role == 'parent'
        can :read, :all
      end
    end
  end
end
