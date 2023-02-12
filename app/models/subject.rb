class Subject < ApplicationRecord
    validates :name, presence: true
    validates :tag, presence: true
    validates :level, presence: true

    has_many :exams
end
