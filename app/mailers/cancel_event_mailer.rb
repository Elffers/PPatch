class CancelEventMailer < ActionMailer::Base

  default from: "admin@thewormhole.com"

  def cancellation(event_id, user_id)
    @event = Event.find(event_id)
    @user = User.find(user_id)
    mail( 
        to: "#{@user.email}", 
        subject: "#{@event.name.capitalize} has been cancelled!"
    )
  end
end
