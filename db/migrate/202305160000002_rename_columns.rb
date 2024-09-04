class RenameColumns < ActiveRecord::Migration[7.0]
  def change
    change_table :demo_accounts do |t|
      t.remove :name
      t.string :account_name
    end

    change_table :demo_topics do |t|
      t.remove :name
      t.string :topic_name
    end

    change_table :demo_quizzes do |t|
      t.string :quiz_name
    end

    drop_table :demo_answer_rubric

    create_table :demo_answer_rubrics do |t|
      t.belongs_to :question
      t.string :rubric

      t.timestamps
    end
  end
end