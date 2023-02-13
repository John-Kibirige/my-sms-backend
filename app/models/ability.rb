class Ability
  include CanCan::Ability

  def initialize(user)
    return if user.nil?

    case user.role
    when 'admin'
      can :manage, :all
    when 'student'
      can :read, :all
    when 'teacher'
      can :read, :all
      can :manage, [Exam, Result]
    when 'parent'
      can :read, :all
    end
  end
end
