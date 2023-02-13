class SubjectTeacher < ApplicationRecord # rubocop:disable Layout/EndOfLine
  belongs_to :subject
  belongs_to :teacher
end
