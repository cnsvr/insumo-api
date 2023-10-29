# frozen_string_literal: true

require 'spec_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.create(:user) }

  context 'validations' do
    before { user } # reqired for validation of uniqueness of email
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_least(3) }
    it { is_expected.to validate_length_of(:name).is_at_most(255) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email) }
  end

  context 'associations' do
    it { is_expected.to have_many(:tasks) }
  end

  it 'should save user with valid name and email' do
    user = User.new(name: 'abc', email: 'test@gmail.com')
    expect(user.valid?).to eq(true)
    expect(user.save).to eq(true)
  end

  it 'should update updated_at when name is updated' do
    user = User.new(name: 'abc', email: 'mahmut@gmail.com')
    expect(user.valid?).to eq(true)
    expect(user.save).to eq(true)

    old_updated_at = user.updated_at
    user.name = 'mahmut'
    expect(user.valid?).to eq(true)
    expect(user.save).to eq(true)
    expect(user.updated_at).not_to eq(old_updated_at)
  end
end
