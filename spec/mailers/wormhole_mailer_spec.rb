require "spec_helper"

describe WormholeMailer do
  context "New Post notification" do
    let!(:user){ create(:user) }
    let!(:unsubscribed_user){create(:user, email_preferences: {"new_post" => "false"} )}
    let!(:post){ create(:post) }
    let!(:mail) { WormholeMailer.new_post(post.id, user.id) }

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
      expect(mail.to).to include user.email
    end

    it 'does not send mail to user who does not want it' do
      expect(mail.to).to_not include unsubscribed_user.email
    end
  end

  context "Event cancellation" do
  end

  context "RSVP confirmation" do
  end
  
end
