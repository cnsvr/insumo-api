# frozen_string_literal: true

class TaskController < ApplicationController
  # GET /get_tasks/:user_id
  def tasks
    service = TaskServices::GetTasks.call(params[:user_id])
    json_response(service.result)
  end

  # POST /start_sync
  def start_sync
    service = TaskServices::SyncTask.call(params[:user_id])
    json_response({ message: 'Sync started', job_id: service.result })
  end
end
