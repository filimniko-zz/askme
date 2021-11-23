class Question < ApplicationRecord
  QUESTION_MAX_LENGTH = 255

  belongs_to :user

  validates :text,
            presence: true,
            length: { maximum: QUESTION_MAX_LENGTH }

  validates :user, presence: true
end
