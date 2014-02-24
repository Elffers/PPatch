class User < ActiveRecord::Base
  validates :uid, presence: true
  validates :name, uniqueness: true
  validates :email, uniqueness: true, allow_nil: true
  validates :phone, uniqueness: true, allow_nil: true
  validates :admin, inclusion: { in: [true, false] }
  has_many :posts # only if admin?
  has_many :rsvps
  has_many :events, through: :rsvps
  has_many :tools
  store_accessor :email_preferences,  :registration,
                                      :new_post,
                                      :rsvp_confirmation,
                                      :event_update,
                                      :event_cancellation

  scope :set_recipients, -> (action){ where("email_preferences -> '#{action}' = 'true'") }

  def self.find_or_create_from_omniauth(auth_hash)
    User.find_by(uid: auth_hash[:uid]) || User.create_from_omniauth(auth_hash)
  end

  def self.create_from_omniauth(auth_hash)
    User.create!(
      uid:        auth_hash[:uid],
      avatar_url: auth_hash[:info][:image],
      name:       auth_hash[:info][:nickname],
      secret:     auth_hash[:credentials][:secret],
      token:      auth_hash[:credentials][:token]
    )
  rescue ActiveRecord::RecordInvalid
    nil
  end

  def update_email_preferences(settings)
    self.email_preferences = settings
    self.save
  rescue ActiveRecord::RecordInvalid
    nil
  end

end
