class RsvpMailer < ActionMailer::Base

  default from: "admin@thewormhole.com"

  def confirmation(event_id, user_id)
    @event = Event.find(event_id)
    @user = User.find(user_id)
    mail( 
        to: "#{@user.email}", 
        subject: "You have RSVP'd to #{@event.name.capitalize}!"
    )
  end
end
