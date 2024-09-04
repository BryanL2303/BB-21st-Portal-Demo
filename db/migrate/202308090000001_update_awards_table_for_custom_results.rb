class UpdateAwardsTableForCustomResults < ActiveRecord::Migration[7.0]
  def change
    change_table :demo_awards do |t|
      t.boolean :custom_description
      t.boolean :custom_columns
      t.remove :require_certification
    end

    change_table :demo_masteries do |t|
      t.boolean :custom_description
      t.boolean :custom_columns
      t.remove :require_certification
    end

    create_table :demo_custom_columns do |t|
      t.belongs_to :demo_awards
      t.belongs_to :demo_masteries
      t.string :column_title

      t.timestamps
    end
  end
end