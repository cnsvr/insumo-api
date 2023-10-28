class TaskMasterController < ApplicationController
    # GET /get_mock_data/:user_id
    def get_mock_data
        user_id = params[:user_id]
        tasks = [
            { id: SecureRandom.uuid, title: 'Task 1', due_date: Date.current, user_id: user_id },
            { id: SecureRandom.uuid, title: 'Task 2', due_date: Date.yesterday, user_id: user_id },
            { id: SecureRandom.uuid, title: 'Task 3', due_date: Date.tomorrow, user_id: user_id },
          ]
          
        json_response(tasks)
    end
end