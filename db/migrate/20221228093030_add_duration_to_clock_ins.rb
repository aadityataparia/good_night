class AddDurationToClockIns < ActiveRecord::Migration[7.0]
  def change
    add_column :clock_ins, :duration, :decimal
  end
end
