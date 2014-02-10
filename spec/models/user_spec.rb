require 'spec_helper'

describe User do
  let(:user){ create(:user) }
  describe 'validations' do
    it 'is valid' do
      expect(user).to be_valid
    end

    it 'must have a name' do
      user.update(name: nil)
      expect(user).to_not be_valid 
    end

    it 'must have unique name' do
      user2 = build(:user, name: user.name)
      user2.valid?
      expect(user2.errors[:name]).to include 'has already been taken'
    end
  end
  
end
