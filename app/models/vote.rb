class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :tip

  enum :vote_type, { concordo: 0, discordo: 1, quente: 2 }

  validates :user_id, uniqueness: { scope: [:tip_id, :vote_type] }

  after_create  :increment_tip_counter
  after_destroy :decrement_tip_counter

  private

  def increment_tip_counter
    tip.increment!(counter_column)
  end

  def decrement_tip_counter
    tip.decrement!(counter_column)
  end

  def counter_column
    case vote_type
    when "concordo"  then :votes_agree_count
    when "discordo"  then :votes_disagree_count
    when "quente"    then :votes_hot_count
    end
  end
end
