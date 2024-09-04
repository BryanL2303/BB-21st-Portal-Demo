class SwitchTopicToAward < ActiveRecord::Migration[7.0]
  def change
    change_table :demo_quizzes do |t|
      t.belongs_to :demo_award
      t.remove :topic_id
    end

    change_table :demo_questions do |t|
      t.belongs_to :demo_award
      t.remove :topic_id
    end
  end
end