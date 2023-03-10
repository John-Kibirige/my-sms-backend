class Subject < ApplicationRecord
  validates :name, presence: true
  validates :tag, presence: true
  validates :level, presence: true

  has_many :exams
  has_many :subject_teachers, dependent: :destroy
  has_many :teachers, through: :subject_teachers

  has_many :subject_students, dependent: :destroy
  has_many :students, through: :subject_students
end
