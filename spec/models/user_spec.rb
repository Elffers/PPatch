require 'spec_helper'

describe User do
  let(:user){ create(:user) }
  describe 'validations' do
    it 'is valid' do
      expect(user).to be_valid
    end

    it 'must have unique name' do
      user2 = build(:user, name: user.name)
      user2.valid?
      expect(user2.errors[:name]).to include 'has already been taken'
    end

    it 'must have uid' do
      user.update(uid: nil)
      expect(user).to_not be_valid 
    end

    it 'must have unique email' do
      user2 = build(:user, email: user.email)
      user2.valid?
      expect(user2.errors[:email]).to include 'has already been taken'
    end


    it 'must have unique phone number' do
      user2 = build(:user, phone: user.phone)
      user2.valid?
      expect(user2.errors[:phone]).to include 'has already been taken'
    end

    it 'must have admin status' do
      user.update(admin: nil)
      expect(user).to_not be_valid
    end
  end

  describe 'create from omniauth hash' do
    let(:user) { User.find_or_create_from_omniauth(OmniAuth.config.mock_auth[:twitter]) }

    it "creates a valid user" do
      expect(user).to be_valid
    end

    context "when it's invalid" do
      it "returns nil" do
        user = User.find_or_create_from_omniauth({uid: nil, info: {}, credentials: {}})
        expect(user).to be_nil
      end
    end
  end

end
