class User < ApplicationRecord
  has_many :clock_ins, -> { order(created_at: :desc) }
  has_many :followed_users, foreign_key: :follower_id, class_name: "Follow"
  has_many :followings, through: :followed_users

  has_many :following_users, foreign_key: :following_id, class_name: "Follow"
  has_many :followers, through: :following_users

  def follow(other_user_id)
    followed_users.create(following_id: other_user_id)
  end

  # Unfollows a user.
  def unfollow(other_user_id)
    follow = followed_users.find_by(following_id: other_user_id)
    return false if not follow
    follow.destroy!
  end

  def clock_in(from, to)
    clock_ins.create(from: from, to: to)
  end

  def feed
    following_ids = "SELECT following_id FROM follows WHERE follower_id = :user_id"
    ClockIn
      .where("(user_id IN (#{following_ids}) OR user_id = :user_id) and created_at >= DATETIME('now','-7 day')", user_id: id)
      .order(duration: :desc)
  end
end
