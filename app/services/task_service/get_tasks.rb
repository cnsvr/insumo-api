# frozen_string_literal: true

module TaskService
  class GetTasks < ApplicationService
    attr_accessor :user_id, :integer

    def validate
      add_error(:must_have_user_id) if user_id.blank?
    end

    def call
      Task.where(user_id:).by_due_date
    end
  end
end
