# frozen_string_literal: true

class TaskController < ApplicationController
  # GET /tasks_by_user/:user_id
  def by_user
    @tasks = Tasks::GetTasks.new(params[:user_id]).call
    json_response(@tasks)
  end

  # POST /start_sync
  def start_sync
    Tasks::SyncTask.new(params[:user_id]).call
    json_response({ message: 'Sync started' })
  end
end
