class EmailJob
  @queue = :email
  def self.perform(post_id, user_id)
    # post = Post.find(post_id)
    # user = User.find(user_id)
    PostMailer.new_post(post_id, user_id).deliver
  end
end