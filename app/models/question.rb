class Question < ApplicationRecord
  QUESTION_MAX_LENGTH = 255

  belongs_to :user
  belongs_to :author, class_name: 'User', optional: true

  validates :text,
            presence: true,
            length: { maximum: QUESTION_MAX_LENGTH }
end
