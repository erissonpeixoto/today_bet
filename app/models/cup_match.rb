class CupMatch < ApplicationRecord
  belongs_to :home_club, class_name: "FootballClub"
  belongs_to :away_club, class_name: "FootballClub"
  has_many :cup_guesses, dependent: :destroy

  enum :phase, { group_stage: 0, round_of_16: 1, quarter: 2, semi: 3, final: 4 }
  enum :status, { scheduled: 0, live: 1, finished: 2 }

  validates :match_date, presence: true

  PHASE_LABELS = {
    "group_stage" => "Fase de Grupos",
    "round_of_16" => "Oitavas de Final",
    "quarter"     => "Quartas de Final",
    "semi"        => "Semifinal",
    "final"       => "Final"
  }.freeze

  after_update :score_all_guesses, if: -> { saved_change_to_status? && finished? }

  def home_team      = home_club.name
  def away_team      = away_club.name
  def title          = "#{home_team} x #{away_team}"
  def phase_label    = PHASE_LABELS[phase]
  def result_label   = finished? ? "#{home_score} x #{away_score}" : nil
  def formatted_date = match_date.strftime("%d/%m %H:%M")
  def open?          = scheduled?

  private

  def score_all_guesses
    cup_guesses.includes(:cup_pool, :user).each(&:calculate_points!)

    affected_pools = cup_guesses.select(:cup_pool_id).distinct.pluck(:cup_pool_id)
    affected_users  = cup_guesses.select(:user_id).distinct.pluck(:user_id)

    CupPoolMembership
      .where(cup_pool_id: affected_pools, user_id: affected_users)
      .each(&:recalculate_score!)
  end
end
