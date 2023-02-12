class Teacher < ApplicationRecord
  belongs_to :user

  has_many :subject_teachers, dependent: :destroy
  has_many :subjects, through: :subject_teachers
end
