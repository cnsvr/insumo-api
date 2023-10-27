class Task < ApplicationRecord
    include BaseModel

    # Validations
    validates :title, presence: true, length: { minimum: 3, maximum: 255 }
    validates :due_date, presence: true, date: { after_or_equal_to: Proc.new { Date.current }, message: 'must be after or equal to today' }

    # Associations
    belongs_to :user, inverse_of: :tasks

    # Scopes
    scope :by_due_date, -> { order(due_date: :asc) }
end
