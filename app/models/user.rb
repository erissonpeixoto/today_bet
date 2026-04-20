class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :tips, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :username, presence: true, uniqueness: { case_sensitive: false },
                       format: { with: /\A[a-zA-Z0-9_]+\z/, message: "só letras, números e _" },
                       length: { minimum: 3, maximum: 30 }

  def admin?
    admin
  end

  def display_name
    "@#{username}"
  end

  def ranking_score
    return self[:ranking_score] if self[:ranking_score]
    correct_pts = tips.where(correct: true).sum  { |t| Tip::CONFIDENCE_WEIGHTS[t.confidence]   || 0 }
    penalty_pts = tips.where(correct: false).sum { |t| Tip::CONFIDENCE_PENALTIES[t.confidence] || 0 }
    correct_pts + penalty_pts
  end

  def judged_tips_count
    self[:judged_tips_count] || tips.where.not(correct: nil).count
  end

  def correct_tips_count
    self[:correct_tips_count] || tips.where(correct: true).count
  end

  def wrong_tips_count
    self[:wrong_tips_count] || tips.where(correct: false).count
  end

  def accuracy_rate
    return 0 if judged_tips_count.zero?
    (correct_tips_count.to_f / judged_tips_count * 100).round(1)
  end

  # baixa=0 → acerto+1/erro 0 | media=1 → acerto+2/erro-1 | alta=2 → acerto+3/erro-2
  SCORE_SQL = <<~SQL.squish.freeze
    COALESCE(SUM(
      CASE
        WHEN tips.correct = TRUE THEN
          CASE tips.confidence WHEN 0 THEN 1 WHEN 1 THEN 2 WHEN 2 THEN 3 ELSE 0 END
        WHEN tips.correct = FALSE THEN
          CASE tips.confidence WHEN 0 THEN 0 WHEN 1 THEN -1 WHEN 2 THEN -2 ELSE 0 END
        ELSE 0
      END
    ), 0)
  SQL

  ACCURACY_SQL = <<~SQL.squish.freeze
    CASE
      WHEN (SELECT COUNT(*) FROM tips t5 WHERE t5.user_id = users.id AND t5.correct IS NOT NULL) > 0
      THEN (SELECT COUNT(*) FROM tips t6 WHERE t6.user_id = users.id AND t6.correct = TRUE)::float
         / (SELECT COUNT(*) FROM tips t5 WHERE t5.user_id = users.id AND t5.correct IS NOT NULL) * 100
      ELSE 0
    END
  SQL

  def self.ranked
    joins("LEFT JOIN tips ON tips.user_id = users.id AND tips.correct IS NOT NULL")
      .select(
        "users.*",
        "#{SCORE_SQL} AS ranking_score",
        "(SELECT COUNT(*) FROM tips t2 WHERE t2.user_id = users.id AND t2.correct = TRUE)  AS correct_tips_count",
        "(SELECT COUNT(*) FROM tips t3 WHERE t3.user_id = users.id AND t3.correct = FALSE) AS wrong_tips_count",
        "(SELECT COUNT(*) FROM tips t4 WHERE t4.user_id = users.id AND t4.correct IS NOT NULL) AS judged_tips_count",
        "#{ACCURACY_SQL} AS accuracy_rate_sql"
      )
      .group("users.id")
      .order("ranking_score DESC, accuracy_rate_sql DESC, correct_tips_count DESC")
  end
end
