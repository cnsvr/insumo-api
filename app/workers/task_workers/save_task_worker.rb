# frozen_string_literal: true

require 'net/http'

module TaskWorkers
  class SaveTaskWorker
    include Sidekiq::Worker
    sidekiq_options queue: :tasks, retry: 3

    attr_reader :user_id, :task_id

    def perform(user_id)
      Rails.logger.info "Sync task for user: #{user_id} started at #{Time.now}"
      @user_id = user_id

      if user.nil?
        Rails.logger.error "User not found for id: #{user_id} with jid: #{jid}"
        return
      end

      # get mock data from task master service
      user_mock_tasks = mock_data['tasks']
      Rails.logger.info "Found #{user_mock_tasks.count} tasks for user: #{user_id}"

      # for each task
      user_mock_tasks.each do |mock_task|
        task_id = mock_task['id']
        @task_id = task_id

        create_or_skip_task(task_id, user_id, mock_task)
      end

      Rails.logger.info "Sync task for user: #{user_id} completed at #{Time.now}"
    ## Any client error will be handled here
    rescue InsumoErrors::BaseError => e
      Rails.logger.error "Error while saving task #{task_id} for user: #{user_id} with jid: #{jid}"
      Rails.logger.error e.to_json
      # raise e to retry
      raise e
    rescue StandardError => e
      Rails.logger.error "Error while saving task #{task_id} for user: #{user_id} with jid: #{jid}"
      Rails.logger.error e.message
      Rails.logger.error e.backtrace.join("\n")
      # raise e to retry
      raise e
    end

    private

    def mock_data
      response = Net::HTTP.get_response(uri)

      case response.code
      when '200'
        JSON.parse(response.body)
      when '401'
        raise InsumoErrors::Authorization.new('Unauthorized from Task Master', 'UNAUTHORIZED', { uri: uri.to_s })
      when '403'
        raise InsumoErrors::Forbidden.new('Forbidden from Task Master', 'FORBIDDEN', { uri: uri.to_s })
      when '404'
        raise InsumoErrors::NotFound.new('Not Found from Task Master', 'NOT_FOUND', { uri: uri.to_s })
      else
        error_message = response.error if response.try(:error).present?
        raise InsumoErrors::InternalServerError.new(error_message, 'INTERNAL_SERVER_ERROR', { uri: uri.to_s })
      end
    end

    def uri
      url = "#{base_url}/task_master/#{user_id}"
      URI(url)
    end

    def base_url
      ENV['TASK_MASTER_SERVICE_URL'] || 'http://localhost:3000'
    end

    def user
      @user ||= User.includes(:tasks).find_by(id: user_id)
    end

    def create_or_skip_task(task_id, user_id, mock_task)
      existing_task = user.tasks.find_by(id: task_id)
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
  end
end
