class FootballClub < ApplicationRecord
  has_many :home_matches, class_name: "Match", foreign_key: :home_club_id, dependent: :nullify
  has_many :away_matches, class_name: "Match", foreign_key: :away_club_id, dependent: :nullify

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  def logo_or_placeholder
    logo_url.presence || nil
  end
end
