class Follow < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :following, class_name: "User"

  validate :check_same
  def check_same
    errors.add(:base, "User can not follow themself") if follower_id == following_id
  end
end
