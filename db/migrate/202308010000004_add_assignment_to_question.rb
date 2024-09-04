class AddAssignmentToQuestion < ActiveRecord::Migration[7.0]
  def change
    change_table :demo_questions do |t|
      t.boolean :assigned
    end
  end
end