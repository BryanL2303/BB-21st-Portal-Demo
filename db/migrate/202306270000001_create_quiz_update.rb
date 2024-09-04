class CreateQuizUpdate < ActiveRecord::Migration[7.0]
  def change
    change_table :demo_questions do |t|
      t.boolean :permanent
    end

    change_table :demo_quizzes do |t|
      t.integer :marks
    end
  end
end