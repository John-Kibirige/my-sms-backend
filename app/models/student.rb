class Student < ApplicationRecord
  belongs_to :parent, dependent: :destroy
  belongs_to :user, dependent: :destroy
  
  has_many :results, dependent: :destroy
  has_many :exams, through: :results

  has_many :subject_students, dependent: :destroy
  has_many :subjects, through: :subject_students
end
