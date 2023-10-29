# frozen_string_literal: true

require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

RSpec.describe TaskWorkers::SaveTaskWorker, type: :worker do
  describe 'testing worker' do
    it 'SaveTaskWorker jobs are enqueued in the tasks queue' do
      expect do
        described_class.perform_async(1)
      end.to change(described_class.jobs, :size).by(1)
      expect(described_class.queue).to eq(:tasks)
    end
  end

  describe 'perform' do
    let(:user) { FactoryBot.create(:user) }

    it 'should save tasks' do
      stub_request(:get, "http://localhost:3000/task_master/#{user.id}")
        .to_return(status: 200, body: mock_data(user.id), headers: {})

      described_class.new.perform(user.id)
      expect(Task.count).to eq(3)

      task = Task.find_by(title: 'Task 1')
      expect(task).to be_present
      expect(task.user_id).to eq(user.id)
      expect(task.due_date).to eq(Date.current)
    end

    it 'should skip task if already exists' do
      stub_request(:get, "http://localhost:3000/task_master/#{user.id}")
        .to_return(status: 200, body: mock_data(user.id), headers: {})

      # Run twice to check if it skips task
      described_class.new.perform(user.id)
      described_class.new.perform(user.id)

      expect(Task.count).to eq(3)
    end

    it 'should not save tasks if user not found' do
      described_class.new.perform(0)
      expect(Task.count).to eq(0)
    end

    it 'should throw error if task master service is down' do
      stub_request(:get, "http://localhost:3000/task_master/#{user.id}")
        .to_return(status: 500, body: '', headers: {})

      expect do
        described_class.new.perform(user.id)
      end.to raise_error(InsumoErrors::BaseError)
    end
  end

  private

  def mock_data(user_id)
    mock_data = { user: { id: user_id, name: 'John Doe', email: 'jonndoe@gmail.com' },
                  tasks: [{ id: '615ca752-77a7-4f4a-82e9-881b91aa294c', title: 'Task 1', due_date: Date.current, user_id: },
                          { id: '192eb103-a519-40c2-9671-e7f7b136117f', title: 'Task 2', due_date: Date.yesterday,
                            user_id: },
                          { id: '90433908-9ded-4489-b840-855e545d39a5', title: 'Task 3', due_date: Date.tomorrow,
                            user_id: }] }
    mock_data.to_json
  end
end
