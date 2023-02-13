class Result < ApplicationRecord # rubocop:disable Layout/EndOfLine
  belongs_to :exam
  belongs_to :student
end
