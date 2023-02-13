class Admin < ApplicationRecord # rubocop:disable Layout/EndOfLine
  belongs_to :user, dependent: :destroy
end
