class PostMailer < ActionMailer::Base
  default from: "from@example.com"

  def new_post(post_id, user_id)
    @post = Post.find(post_id)
    @user = User.find(user_id)
    mail( 
        to: "#{@user.email}", 
        subject: "The Worm Hole has updated its Blahg."
    )
  end
end
