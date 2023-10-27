module BaseModel
    extend ActiveSupport::Concern

    included do
        # Callbacks
        before_save :set_id, set_created_at: true
        before_update :set_updated_at
        before_destroy :set_deleted_at

        # Validations
        validates :id, presence: true, uniqueness: true
        validates :created_at, presence: true
        validates :updated_at, presence: true, on: :update
        validates :deleted_at, presence: true, on: :destroy

        # Scopes
        default_scope { where(deleted_at: nil) }
        scope :deleted, -> { unscoped.where.not(deleted_at: nil) }
        
        # Class Methods
        class << self
            def find_by_id(id)
                self.find_by(id: id)
            end
        end

        # Instance Methods
        def set_id
            self.id = SecureRandom.id
        end
        
        def set_created_at
            self.created_at = Time.now
        end

        def set_updated_at
            self.updated_at = Time.now
        end

        def set_deleted_at
            self.deleted_at = Time.now
        end

    end
end