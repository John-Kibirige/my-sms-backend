class Student < ApplicationRecord
  belongs_to :parent
  belongs_to :user
  has_many :results, dependent: :destroy
  has_many :exams, through: :results
end
