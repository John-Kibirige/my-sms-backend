class Exam < ApplicationRecord
  has_many :results, dependent: :destroy
  validates :name, presence: true, uniqueness: true

  belongs_to :subject
  has_many :students, through: :results
end
