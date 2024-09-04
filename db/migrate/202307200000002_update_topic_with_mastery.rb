class UpdateTopicWithMastery < ActiveRecord::Migration[7.0]
  def change
    change_table :demo_quizzes do |t|
      t.belongs_to :demo_mastery
    end

    change_table :demo_questions do |t|
      t.belongs_to :demo_mastery
    end
  end
end