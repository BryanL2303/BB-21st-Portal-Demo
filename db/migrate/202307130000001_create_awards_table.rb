class CreateAwardsTable < ActiveRecord::Migration[7.0]
  def change
    create_table :demo_awards do |t|
      t.string :badge_name
      t.string :badge_requirements
      t.string :results_description
      t.string :recommended_level

      t.timestamps
    end

    change_table :demo_accounts do |t|
      t.integer :level
    end
  end
end