class Subject < ApplicationRecord
    validates :name, presence: true
    validates :tag, presence: true
    validates :level, presence: true
end
