class CreateCommentsWithGrading < ActiveRecord::Migration[7.0]
  def change
    change_table :demo_assignment_answers do |t|
      t.string :comments
    end
  end
end