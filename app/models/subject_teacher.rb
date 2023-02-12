class SubjectTeacher < ApplicationRecord
  belongs_to :subject
  belongs_to :teacher
end
