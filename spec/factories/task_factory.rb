# frozen_string_literal: true

require 'faker'

FactoryBot.define do
  factory :task do
    association :user, factory: :user
    title { Faker::Lorem.sentence }
    due_date { Faker::Date.forward(days: 23) }
  end
end
