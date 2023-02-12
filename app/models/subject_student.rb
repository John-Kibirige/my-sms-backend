class SubjectStudent < ApplicationRecord
  belongs_to :subject
  belongs_to :student
end
