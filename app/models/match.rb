class Match < ApplicationRecord
  belongs_to :home_club, class_name: "FootballClub"
  belongs_to :away_club, class_name: "FootballClub"
  has_many :tips, dependent: :destroy

  enum :status, { scheduled: 0, live: 1, finished: 2 }

  validates :home_club, :away_club, :league, :match_date, presence: true

  scope :today, -> { where(match_date: Date.today.all_day) }
  scope :upcoming, -> { where("match_date >= ?", Time.current).order(:match_date) }
  scope :recent, -> { order(match_date: :desc) }

  def home_team
    home_club&.name
  end

  def away_team
    away_club&.name
  end

  def title
    "#{home_team} x #{away_team}"
  end

  def formatted_date
    match_date.strftime("%d/%m %H:%M")
  end
end
