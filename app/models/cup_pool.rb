class CupPool < ApplicationRecord
  belongs_to :creator, class_name: "User"
  has_many :cup_pool_memberships, dependent: :destroy
  has_many :members, through: :cup_pool_memberships, source: :user
  has_many :cup_guesses, dependent: :destroy

  enum :status, { active: 0, finished: 1 }

  before_create :generate_invite_code

  validates :name, presence: true, length: { minimum: 3, maximum: 50 }

  def member?(user)
    cup_pool_memberships.exists?(user: user)
  end

  def membership_for(user)
    cup_pool_memberships.find_by(user: user)
  end

  private

  def generate_invite_code
    loop do
      self.invite_code = SecureRandom.alphanumeric(6).upcase
      break unless CupPool.exists?(invite_code: invite_code)
    end
  end
end
