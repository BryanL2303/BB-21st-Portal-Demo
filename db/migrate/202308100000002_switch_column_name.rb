class SwitchColumnName < ActiveRecord::Migration[7.0]
  def change
    change_table :demo_awards do |t|
      t.remove :custom_columns
      t.boolean :has_custom_columns
    end

    change_table :demo_masteries do |t|
      t.remove :custom_columns
      t.boolean :has_custom_columns
    end
  end
end