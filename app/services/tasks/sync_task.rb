module Tasks
    class SyncTask
        attr_reader :user_id
        attr_reader :job_id # Sidekiq job id
        
        def initialize(user_id)
            @user_id = user_id
        end

        def call            
            @job_id = Tasks::SaveTaskWorker.perform_async(user_id)
        end
    end
end
