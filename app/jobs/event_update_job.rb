class EventUpdateJob
  extend HerokuResqueAutoscaler
  @queue = :event_update
  
  def self.perform(event_id, user_id)
    WormholeMailer.event_update(event_id, user_id).deliver
  end
end