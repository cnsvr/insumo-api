class User < ApplicationRecord
    include BaseModel
    # Validations
    validates :email, presence: true, uniqueness: true

    # Associations
    has_many :tasks, dependent: :destroy

    # Scopes
    scope :by_email, -> { order(email: :asc) }
end
