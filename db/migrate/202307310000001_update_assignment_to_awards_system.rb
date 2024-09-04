class UpdateAssignmentToAwardsSystem < ActiveRecord::Migration[7.0]
  def change
    change_table :demo_assignments do |t|
      t.remove :topic_name
      t.belongs_to :demo_award
      t.belongs_to :demo_mastery
    end
  end
end