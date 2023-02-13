class User < ApplicationRecord
    has_secure_password

    validates :user_name, presence: true, uniqueness: true
    validates :password, presence: true, length: { minimum: 8 }
    validates :role, presence: true

    has_one :admin
    has_one :teacher
    has_one :parent
    has_one :student

end
