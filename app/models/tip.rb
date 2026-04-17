class Tip < ApplicationRecord
  belongs_to :user
  belongs_to :match

  enum :market, {
    vitoria_mandante:           0,
    vitoria_visitante:          1,
    empate:                     2,
    ambos_marcam:               3,
    over_1_5:                   4,
    under_1_5:                  5,
    over_2_5:                   6,
    under_2_5:                  7,
    mais_escanteios_mandante:   8,
    mais_escanteios_visitante:  9,
    menos_escanteios_mandante:  10,
    menos_escanteios_visitante: 11
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
    "vitoria_mandante"          => "Vitória Mandante",
    "vitoria_visitante"         => "Vitória Visitante",
    "empate"                    => "Empate",
    "ambos_marcam"              => "Ambos Marcam",
    "over_1_5"                  => "Over 1.5 Gols",
    "under_1_5"                 => "Under 1.5 Gols",
    "over_2_5"                  => "Over 2.5 Gols",
    "under_2_5"                 => "Under 2.5 Gols",
    "mais_escanteios_mandante"  => "Mais Escanteios (Mandante)",
    "mais_escanteios_visitante" => "Mais Escanteios (Visitante)",
    "menos_escanteios_mandante"  => "Menos Escanteios (Mandante)",
    "menos_escanteios_visitante" => "Menos Escanteios (Visitante)"
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
