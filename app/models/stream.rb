class Stream < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :level, presence: true, inclusion: { in: %w[o a] }

  has_many :student_streams, dependent: :destroy
  has_many :students, through: :student_streams
end
