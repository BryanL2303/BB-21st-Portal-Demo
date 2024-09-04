class UpdateMasteriesTable < ActiveRecord::Migration[7.0]
  def change
    change_table :demo_masteries do |t|
      t.belongs_to :demo_award
    end
  end
end