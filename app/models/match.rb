class Match < ApplicationRecord
  has_many :tips, dependent: :destroy

  enum :status, { scheduled: 0, live: 1, finished: 2 }

  validates :home_team, :away_team, :league, :match_date, presence: true

  scope :today, -> { where(match_date: Date.today.all_day) }
  scope :upcoming, -> { where("match_date >= ?", Time.current).order(:match_date) }
  scope :recent, -> { order(match_date: :desc) }

  def title
    "#{home_team} x #{away_team}"
  end

  def formatted_date
    match_date.strftime("%d/%m %H:%M")
  end
end
