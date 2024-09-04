class UpdateMarksToFloat < ActiveRecord::Migration[7.0]
  def change
    change_table :demo_questions do |t|
      t.remove :marks
      t.float :marks
    end

    change_table :demo_quizzes do |t|
      t.remove :marks
      t.float :marks
    end

    change_table :demo_assigned_accounts do |t|
      t.remove :score
      t.float :score
    end

    change_table :demo_assignment_answers do |t|
      t.remove :score
      t.float :score
    end
  end
end