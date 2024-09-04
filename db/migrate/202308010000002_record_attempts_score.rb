class RecordAttemptsScore < ActiveRecord::Migration[7.0]
  def change
    create_table :demo_attempt_scores do |t|
      t.belongs_to :demo_assigned_account
      t.float :score
      t.integer :attempt

      t.timestamps
    end
  end
end