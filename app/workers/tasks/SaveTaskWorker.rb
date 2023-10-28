require 'net/http'

module Tasks
    class SaveTaskWorker
        include Sidekiq::Job
        sidekiq_options queue: 'tasks', retry: 3
        attr_reader :user_id
        attr_reader :task_id

        def perform(user_id)
            @user_id = user_id
            user = User.includes(:tasks).find_by(id: user_id)
            if user.nil?
                Rails.logger.error "User not found for id: #{user_id}"
                return
            end
            # get mock data from external service
            mock_data = get_mock_data()
            # for each task
            mock_data.each do |mock_task|
                task_id = mock_task['id']
                @task_id = task_id
                # check if task already exists
                existing_task = user.tasks.find_by(id: task_id)
                # if not exist
                if existing_task.nil?
                    Rails.logger.info "Creating new task for user: #{user_id}"
                    # create
                    task = Task.new
                    task.id = task_id
                    task.user = user
                    task.title = mock_task['title']
                    task.due_date = mock_task['due_date']
                    task.save!
                    Rails.logger.info "Task #{task_id} created for user: #{user_id}"
                else
                    Rais.logger.info "Task #{task_id} already exists for user: #{user_id}"
                end
            end
        rescue StandardError => e
            Rails.logger.error "Error while saving task #{task_id} for user: #{user_id}"
            Rails.logger.error e.message
            Rails.logger.error e.backtrace.join("\n")
        end

        private 
        
        def get_mock_data
            response = Net::HTTP.get(uri)
            JSON.parse(response)
        end

        def uri
            url = "http://localhost:3000/get_mock_data/#{user_id}"
            URI(url)
        end
    end
end
