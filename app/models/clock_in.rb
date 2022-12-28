class ClockIn < ApplicationRecord
  belongs_to :user

  before_save :calculate_duration
  validates :from, presence: true
  validates :to, presence: true
  validate :check_times

  private

  def calculate_duration
    self.duration = (to - from) / 60
  end

  def check_times
    errors.add(:base, "To time should be greater than from time") if to and from and to < from
  end
end
