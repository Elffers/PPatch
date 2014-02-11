require 'spec_helper'

describe Post do
  let(:post){ create(:post) }
  describe 'validations' do
    it 'is valid' do
      expect(post).to be_valid
    end

    it 'must have a title' do
      post.title = nil
      expect(post).to be_invalid
    end

    it 'must have a body' do
      post.body = nil
      expect(post).to be_invalid
    end

    it 'must have unique title' do
      post2 = build(:post, title: post.title)
      post2.valid?
      expect(post2.errors[:title]).to include 'has already been taken'
    end
  end

  describe 'associations' do
    it "belongs to user" do
      expect(post.user).to be_an_instance_of(User)
    end

  end
end
