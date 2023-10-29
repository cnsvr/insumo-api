# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TaskServices::GetTasks do
  let(:task) { FactoryBot.create(:task) }

  context 'when user_id is blank' do
    it 'should return error' do
      service = TaskServices::GetTasks.call(nil)
      expect(service.failed?).to eq(true)
      expect(service.errors).to eq([:must_have_user_id])
    end
  end

  context 'when user_id is present' do
    it 'should return tasks' do
      service = TaskServices::GetTasks.call(task.user_id)
      expect(service.succeeded?).to eq(true)
      expect(service.result.count).to eq(1)
      expect(service.result.first.id).to eq(task.id)
    end
  end
end
