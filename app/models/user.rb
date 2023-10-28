class User < ApplicationRecord
    include BaseModel
    # Validations
    validates :name, presence: true, length: { minimum: 3, maximum: 255 }
    validates :email, presence: true, uniqueness: true

    # Associations
    has_many :tasks, dependent: :destroy
end
