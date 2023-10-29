# frozen_string_literal: true

require 'swagger_helper'

describe 'Task API' do
  path '/get_tasks/{user_id}' do
    get 'Retrieves tasks by user_id' do
      tags 'Tasks'
      produces 'application/json'
      parameter name: :user_id, in: :path, type: :string

      response '200', 'tasks found' do
        schema type: :array,
               items: {
                 properties: {
                   id: { type: :integer },
                   title: { type: :string },
                   due_date: { type: :string },
                   user_id: { type: :integer }
                 }
               }

        let(:user_id) { FactoryBot.create(:user).id }
        run_test!
      end
    end
  end

  path '/start_sync' do
    post 'Start sync tasks' do
      tags 'Tasks'
      consumes 'application/json'
      parameter name: :user_id, in: :body, schema: {
        type: :object,
        properties: {
          user_id: { type: :integer }
        },
        required: ['user_id']
      }

      response '200', 'sync started' do
        let(:user_id) { FactoryBot.create(:user).id }
        run_test!
      end
    end
  end
end
