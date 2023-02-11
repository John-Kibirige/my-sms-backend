class Stream < ApplicationRecord
    validates :name, presence: true, uniqueness: true
    validates :level, presence: true, inclusion: { in: %w[o a] }
end
