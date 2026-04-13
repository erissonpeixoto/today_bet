class Tip < ApplicationRecord
  belongs_to :user
  belongs_to :match

  enum :market, {
    over_2_5:        0,
    under_2_5:       1,
    ambos_marcam:    2,
    vitoria_mandante: 3,
    vitoria_visitante: 4,
    empate:          5,
    mais_escanteios: 6,
    menos_escanteios: 7,
    over_1_5:        8,
    under_1_5:       9
  }

  enum :confidence, { baixa: 0, media: 1, alta: 2 }

  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :justification, presence: true, length: { minimum: 20, maximum: 500 }
  validates :market, :confidence, presence: true
  validates :user_id, uniqueness: {
    scope: [:match_id, :market],
    message: "já postou um palpite para esse mercado nesse jogo"
  }

  scope :most_hot,       -> { order(votes_hot_count: :desc) }
  scope :most_agreed,    -> { order(votes_agree_count: :desc) }
  scope :most_commented, -> { order(comments_count: :desc) }
  scope :most_confident, -> { where(confidence: :alta).order(votes_agree_count: :desc) }

  MARKET_LABELS = {
    "over_2_5"          => "Over 2.5 Gols",
    "under_2_5"         => "Under 2.5 Gols",
    "ambos_marcam"      => "Ambos Marcam",
    "vitoria_mandante"  => "Vitória Mandante",
    "vitoria_visitante" => "Vitória Visitante",
    "empate"            => "Empate",
    "mais_escanteios"   => "Mais Escanteios",
    "menos_escanteios"  => "Menos Escanteios",
    "over_1_5"          => "Over 1.5 Gols",
    "under_1_5"         => "Under 1.5 Gols"
  }.freeze

  CONFIDENCE_LABELS = {
    "baixa" => "Baixa 🟡",
    "media" => "Média 🟠",
    "alta"  => "Alta 🔴"
  }.freeze

  def market_label
    MARKET_LABELS[market] || market.humanize
  end

  def confidence_label
    CONFIDENCE_LABELS[confidence] || confidence.humanize
  end

  def total_votes
    votes_agree_count + votes_disagree_count + votes_hot_count
  end

  def share_text(rank)
    "##{rank} no #{match.title} | #{market_label} (Confiança #{confidence_label.gsub(/\s\S+$/, '')}) - Bet do Dia 🔥 betdodia.com"
  end
end
