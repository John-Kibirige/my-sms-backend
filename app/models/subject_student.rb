class SubjectStudent < ApplicationRecord # rubocop:disable Layout/EndOfLine
  belongs_to :subject
  belongs_to :student
end
