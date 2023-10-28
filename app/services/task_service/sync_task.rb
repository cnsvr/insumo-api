# frozen_string_literal: true

module TaskService
  class SyncTask < ApplicationService
    attribute :user_id, :integer

    def validate
      add_error(:must_have_user_id) if user_id.blank?
    end

    def call
      Tasks::SaveTaskWorker.perform_async(user_id)
    end
  end
end
