class CupPoolMembership < ApplicationRecord
  belongs_to :cup_pool
  belongs_to :user

  enum :role, { member: 0, owner: 1 }

  def recalculate_score!
    total = cup_pool.cup_guesses.where(user: user).sum(:points_earned)
    update_column(:total_score, total)
  end
end
