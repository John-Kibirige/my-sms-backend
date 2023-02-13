class Parent < ApplicationRecord # rubocop:disable Layout/EndOfLine
  belongs_to :user, dependent: :destroy
  has_many :students
end
