class PostMailer < ActionMailer::Base
  # before_action :set_recipients

  default from: "admin@thewormhole.com"
          # to: Proc.new { @recipients.pluck(:email) }

  def new_post(post_id, user_id)
    @post = Post.find(post_id)
    @user = User.find(user_id)
    mail( 
        to: "#{@user.email}", 
        subject: "The Worm Hole has updated its Blahg."
    )
  end

  private

  # def set_recipients
  #   @recipients = User.where(preferences: true)
  # end
end
