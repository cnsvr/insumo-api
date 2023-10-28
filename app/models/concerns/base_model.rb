module BaseModel
    extend ActiveSupport::Concern

    included do
        # Callbacks
        before_save :set_id
        before_create :set_created_at
        before_update :set_updated_at

        # Scopes
        scope :by_created_at, -> { order(created_at: :asc) }
        scope :by_updated_at, -> { order(updated_at: :asc) }
        
        # Class Methods
        class << self
            def find_by_id(id)
                self.find_by(id: id)
            end
        end

        # Instance Methods
        private
        def set_id
            self.id ||= SecureRandom.uuid
        end
        
        def set_created_at
            self.created_at = Time.now
        end

        def set_updated_at
            self.updated_at = Time.now
        end
    end
end