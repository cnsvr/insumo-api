# frozen_string_literal: true

module TaskServices
  class GetTasks < ApplicationService
    attr_reader :user_id, :integer

    def validate
      add_error(:must_have_user_id) if user_id.blank?
    end

    def initialize(user_id)
      super
      @user_id = user_id
    end

    def call
      Task.where(user_id:).by_due_date
    end
  end
end
