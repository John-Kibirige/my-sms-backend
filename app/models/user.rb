class User < ApplicationRecord
    has_secure_password

    validates :user_name, presence: true, uniqueness: true
    validates :password, presence: true, length: { minimum: 8 }
    validates :role, presence: true

    has_many :admins
end
