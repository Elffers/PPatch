class RsvpJob
  @queue = :rsvp
  
  def self.perform(event_id, user_id)
    RsvpMailer.confirmation(event_id, user_id).deliver
  end
end