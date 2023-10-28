# frozen_string_literal: true

require 'net/http'

module Tasks
  class SaveTaskWorker
    include Sidekiq::Job
    sidekiq_options queue: 'tasks', retry: 3
    attr_reader :user_id
    attr_reader :task_id

    def perform(user_id)
      Rails.logger.info "Sync task for user: #{user_id} started at #{Time.now}"
      @user_id = user_id
      user = User.includes(:tasks).find_by(id: user_id)
      if user.nil?
        Rails.logger.error "User not found for id: #{user_id}"
        return
      end
      # get mock data from external service
      user_mock_tasks = mock_data['tasks']
      Rails.logger.info "Found #{user_mock_tasks.count} tasks for user: #{user_id}"
      # for each task
      user_mock_tasks.each do |mock_task|
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
          Rails.logger.info "Task #{task_id} already exists for user: #{user_id}"
        end
      end

      Rails.logger.info "Sync task for user: #{user_id} completed at #{Time.now}"
    ## Any client error will be handled here
    rescue ClientErrors::BaseError => e
      Rails.logger.error "Error while saving task #{task_id} for user: #{user_id}"
      Rails.logger.error e.message
      Rails.logger.error e.backtrace.join("\n")
      # raise e to retry
      raise e
    rescue StandardError => e
      Rails.logger.error "Error while saving task #{task_id} for user: #{user_id}"
      Rails.logger.error e.message
      Rails.logger.error e.backtrace.join("\n")
      # raise e to retry
      raise e
    end

    private

    def mock_data
      response = Net::HTTP.get(uri)
      ## Possible error situations like 401
      # 401 Unauthorized, 403 Forbidden, 404 Not Found, 500 Internal Server Error
      case response.code
      when '401'
        raise ClientErrors::Authorization.new('Unauthorized', 'UNAUTHORIZED', Struct.new({ uri: }))
      when '403'
        raise ClientErrors::Forbidden.new('Forbidden', 'FORBIDDEN', Struct.new({ uri: }))
      when '404'
        raise ClientErrors::NotFound.new('Not Found', 'NOT_FOUND', Struct.new({ uri: }))
      end

      JSON.parse(response)
    rescue StandardError => e
      raise ServerErrors::InternalServerError.new(e.message, 'INTERNAL_SERVER_ERROR', Struct.new({ uri: }))
    end

    def uri
      url = "#{base_url}/task_master/#{user_id}"
      URI(url)
    end

    def base_url
      ENV['TASK_MASTER_SERVICE_URL'] || 'http://localhost:3001'
    end
  end
end
