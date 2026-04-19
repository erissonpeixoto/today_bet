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
    self[:ranking_score] || tips.where(correct: true)
                                .sum { |t| Tip::CONFIDENCE_WEIGHTS[t.confidence] || 0 }
  end

  def judged_tips_count
    self[:judged_tips_count] || tips.where.not(correct: nil).count
  end

  def correct_tips_count
    self[:correct_tips_count] || tips.where(correct: true).count
  end

  def accuracy_rate
    return 0 if judged_tips_count.zero?
    (correct_tips_count.to_f / judged_tips_count * 100).round(1)
  end

  def self.ranked
    joins("LEFT JOIN tips ON tips.user_id = users.id AND tips.correct = TRUE")
      .select(
        "users.*",
        "COALESCE(SUM(CASE tips.confidence WHEN 0 THEN 1 WHEN 1 THEN 2 WHEN 2 THEN 3 END), 0) AS ranking_score",
        "(SELECT COUNT(*) FROM tips t2 WHERE t2.user_id = users.id AND t2.correct = TRUE) AS correct_tips_count",
        "(SELECT COUNT(*) FROM tips t3 WHERE t3.user_id = users.id AND t3.correct IS NOT NULL) AS judged_tips_count"
      )
      .group("users.id")
      .order("ranking_score DESC, correct_tips_count DESC")
  end
end
