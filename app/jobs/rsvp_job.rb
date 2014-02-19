class RsvpJob
  @queue = :rsvp
  
  def self.perform(event_id, user_id)
    WormholeMailer.rsvp_confirmation(event_id, user_id).deliver
  end
end