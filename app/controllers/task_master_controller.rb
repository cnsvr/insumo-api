# frozen_string_literal: true

class TaskMasterController < ApplicationController
  # GET /task_master/:user_id
  def index
    user_id = params[:user_id]
    mock_data = { user: { id: user_id, name: 'John Doe', email: 'jonndoe@gmail.com' },
                  tasks: [{ id: '615ca752-77a7-4f4a-82e9-881b91aa294c', title: 'Task 1', due_date: Date.current },
                          { id: '192eb103-a519-40c2-9671-e7f7b136117f', title: 'Task 2', due_date: Date.yesterday },
                          { id: '90433908-9ded-4489-b840-855e545d39a5', title: 'Task 3', due_date: Date.tomorrow }] }
    json_response(mock_data)
  end
end
