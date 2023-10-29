# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'TaskController', type: :request do
  describe 'GET /tasks_by_user/:user_id' do
    let(:task) { FactoryBot.create(:task) }

    context 'when user_id is present' do
      it 'should call TaskServices::GetTasks and return tasks' do
        expect(TaskServices::GetTasks).to receive(:call).with(task.user_id).and_call_original
        get "/tasks_by_user/#{task.user_id}"
        expect(response.status).to eq(200)
        expect(response.body).to eq([task].to_json)
      end
    end
  end

  describe 'POST /start_sync' do
    let(:user) { FactoryBot.create(:user) }

    context 'when user_id is present' do
      it 'should call TaskServices::SyncTask and return job_id' do
        expect(TaskServices::SyncTask).to receive(:call).with(user.id).and_return(Struct.new(:result).new('JOB_ID'))
        post '/start_sync', params: { user_id: user.id }
        expect(response.status).to eq(200)
        expect(response.body).to eq({ message: 'Sync started', job_id: 'JOB_ID' }.to_json)
      end
    end
  end
end
