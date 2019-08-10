require 'rails_helper'

RSpec.describe Reward, type: :model do
  it { should belong_to(:question) }

  it { should validate_presence_of :title }

  it 'has one attaced files' do
    expect(Reward.new.image).to be_an_instance_of(ActiveStorage::Attached::One)
  end
end
