# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:task) { FactoryBot.create(:task) }

  context 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_length_of(:title).is_at_least(3) }
    it { is_expected.to validate_length_of(:title).is_at_most(255) }
    it { is_expected.to validate_presence_of(:due_date) }
  end

  context 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  it 'should save task with valid title, due_date and user' do
    task = Task.new(title: 'abc', due_date: Time.now, user: FactoryBot.create(:user))
    expect(task.valid?).to eq(true)
    expect(task.save).to eq(true)
  end

  it 'should update updated_at when title is updated' do
    task = Task.new(title: 'abc', due_date: Time.now, user: FactoryBot.create(:user))
    expect(task.valid?).to eq(true)
    expect(task.save).to eq(true)

    old_updated_at = task.updated_at
    task.title = 'abcd'
    expect(task.valid?).to eq(true)
    expect(task.save).to eq(true)
    expect(task.updated_at).not_to eq(old_updated_at)
  end
end
