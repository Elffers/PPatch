require "spec_helper"

describe PostMailer do
  let!(:user){ create(:user) }
  let!(:unsubscribed_user){create(:user, preferences: false)}
  let!(:post){ create(:post) }
  let!(:mail) { PostMailer.new_post(post.id, user.id) }

  it 'sends mail to user email' do
    expect(mail.to).to include user.email
  end

  it 'sends mail from admin' do
    expect(mail.from).to include "admin@thewormhole.com"
  end 

  it 'sends sets subject' do
    expect(mail.subject).to eq "The Worm Hole has updated its Blahg."
  end 

  it 'sends mail to user who wants it' do
    p mail.inspect
    expect(mail.to).to include user.email
  end
end
