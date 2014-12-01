class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can [:edit, :update, :destroy], Note, user_id: user.id
  end
end
