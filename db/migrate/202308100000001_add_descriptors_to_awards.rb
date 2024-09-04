class AddDescriptorsToAwards < ActiveRecord::Migration[7.0]
  def change
    change_table :demo_awards do |t|
      t.string :description_cue
      t.boolean :has_results
      t.boolean :has_pass
    end

    change_table :demo_masteries do |t|
      t.string :description_cue
      t.boolean :has_results
      t.boolean :has_pass
    end
  end
end