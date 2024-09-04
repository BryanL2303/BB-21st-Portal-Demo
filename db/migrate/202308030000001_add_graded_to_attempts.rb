class AddGradedToAttempts < ActiveRecord::Migration[7.0]
  def change
    change_table :demo_attempt_scores do |t|
      t.boolean :graded
    end
  end
end