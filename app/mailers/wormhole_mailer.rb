class WormholeMailer < ActionMailer::Base
  before_action :set_event_and_user, except: [:new_post]

  default from: "admin@thewormhole.com"
          # to: Proc.new { @recipients.pluck(:email) }

  def new_post(post_id, user_id)
    @post = Post.find(post_id)
    @user = User.find(user_id)
    mail( 
        to: @user.email, 
        subject: "The Worm Hole has updated its Blahg."
    )
  end

  def rsvp_confirmation(event_id, user_id)
    mail( 
        to: @user.email, 
        subject: "You have RSVP'd to #{@event.name.capitalize}!"
    )
  end

  def event_update(event_id, user_id)
    mail( 
        to: @user.email, 
        subject: "#{@event.name.capitalize} has been updated!"
    )
  end

  def event_cancellation(event_id, user_id)
    mail( 
        to: @user.email, 
        subject: "#{@event.name.capitalize} has been cancelled!"
    )
  end

  private

  def set_event_and_user(event_id, user_id)
    @event = Event.find(event_id)
    @user = User.find(user_id)
  end

end
