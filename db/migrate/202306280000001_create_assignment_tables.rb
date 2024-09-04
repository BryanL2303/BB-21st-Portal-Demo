class CreateAssignmentTables < ActiveRecord::Migration[7.0]
  def change
    create_table :demo_assignments do |t|
      t.belongs_to :account

      t.timestamps
    end

    create_table :demo_assigned_accounts do |t|
      t.belongs_to :account
      t.belongs_to :assignment
      t.integer :score
      t.integer :attempts

      t.timestamps
    end

    change_table :demo_quizzes do |t|
      t.boolean :assigned
    end
  end
end