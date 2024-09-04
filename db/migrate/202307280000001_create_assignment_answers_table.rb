class CreateAssignmentAnswersTable < ActiveRecord::Migration[7.0]
  def change
    create_table :demo_assignment_answers do |t|
      t.belongs_to :demo_account
      t.belongs_to :demo_assignment
      t.belongs_to :demo_question
      t.belongs_to :demo_question_option
      t.string :question_type
      t.string :answer
      t.integer :score

      t.timestamps
    end
  end
end