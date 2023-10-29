# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TaskServices::SyncTask do
  let(:user) { FactoryBot.create(:user) }
  let(:task) { FactoryBot.create(:task) }

  context 'when user_id is blank' do
    it 'should return error' do
      service = TaskServices::SyncTask.call(nil)
      expect(service.failed?).to eq(true)
      expect(service.errors).to eq([:must_have_user_id])
    end
  end

  context 'when user_id is present' do
    it 'should call SaveTaskWorker with user_id' do
      expect(TaskWorkers::SaveTaskWorker).to receive(:perform_async).with(user.id)
      service = TaskServices::SyncTask.call(user.id)
      expect(service.succeeded?).to eq(true)
    end
  end
end
