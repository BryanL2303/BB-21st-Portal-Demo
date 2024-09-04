class FixTypoInCustomColumn < ActiveRecord::Migration[7.0]
  def change
    change_table :demo_custom_columns do |t|
      t.belongs_to :demo_award
      t.belongs_to :demo_mastery
      t.remove :demo_awards_id
      t.remove :demo_masteries_id
    end
  end
end