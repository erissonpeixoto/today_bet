class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :tip, counter_cache: :comments_count

  validates :content, presence: true, length: { minimum: 3, maximum: 280 }
end
