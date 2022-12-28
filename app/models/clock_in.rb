class ClockIn < ApplicationRecord
  belongs_to :user

  before_save :calculate_size
  validates :to, presence: true
  validates :from, presence: true
  validate :check_times

  private

  def calculate_size
    self.duration = (to - from) / 60
  end

  def check_times
    errors.add(:base, "To time should be greater than from time") if to and from and to < from
  end
end
