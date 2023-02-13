class StudentStream < ApplicationRecord # rubocop:disable Layout/EndOfLine
  belongs_to :student
  belongs_to :stream
end
