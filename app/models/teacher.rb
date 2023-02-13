class Teacher < ApplicationRecord # rubocop:disable Layout/EndOfLine
  belongs_to :user, dependent: :destroy

  has_many :subject_teachers, dependent: :destroy
  has_many :subjects, through: :subject_teachers
end
