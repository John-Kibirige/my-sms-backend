class Exam < ApplicationRecord
  belongs_to :subject

  validates :name, presence: true, uniqueness: true
end
