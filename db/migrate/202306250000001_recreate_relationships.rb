class RecreateRelationships < ActiveRecord::Migration[7.0]
  def change
    drop_table :demo_quiz_questions

    create_table :demo_quiz_questions do |t|
      t.belongs_to :quiz
      t.belongs_to :question

      t.timestamps
    end
  end
end