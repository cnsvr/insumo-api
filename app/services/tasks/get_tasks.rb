module Tasks
    class GetTasks
        attr_reader :user_id
        
        def initialize(user_id)
            @user_id = user_id
        end
        
        def call
            Task.where(user_id: @user_id).by_due_date
        end
    end
end
