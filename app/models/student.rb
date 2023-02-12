class Student < ApplicationRecord
  belongs_to :parent
  belongs_to :user, dependent: :destroy
  
  has_many :results, dependent: :destroy
  has_many :exams, through: :results

  has_many :subject_students, dependent: :destroy
  has_many :subjects, through: :subject_students

  has_many :student_streams, dependent: :destroy
  has_many :streams, through: :student_streams
end
