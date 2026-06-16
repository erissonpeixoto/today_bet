class CupGuess < ApplicationRecord
  belongs_to :cup_pool
  belongs_to :cup_match
  belongs_to :user

  validates :home_score_guess, :away_score_guess,
            presence: true,
            numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validate :match_open, on: :create

  def calculate_points!
    return unless cup_match.finished?

    points = if exact_score?  then 3
    elsif correct_result? then 1
    else 0
    end

    update_columns(points_earned: points, locked: true)
  end

  private

  def exact_score?
    home_score_guess == cup_match.home_score &&
      away_score_guess == cup_match.away_score
  end

  def correct_result?
    guess_result == match_result
  end

  # Returns -1, 0, or 1 (away win, draw, home win)
  def guess_result  = home_score_guess <=> away_score_guess
  def match_result  = cup_match.home_score <=> cup_match.away_score

  def match_open
    errors.add(:base, "Palpites fechados — a partida já começou") if cup_match.live? || cup_match.finished?
  end
end
