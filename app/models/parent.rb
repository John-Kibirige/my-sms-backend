class Parent < ApplicationRecord
  belongs_to :user, dependent: :destroy
  has_many :students
end
