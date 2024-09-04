class AddAssignmentNames < ActiveRecord::Migration[7.0]
  def change
    change_table :demo_assignments do |t|
      t.string :assignment_name
    end
  end
end