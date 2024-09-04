class AddCertificationToAward < ActiveRecord::Migration[7.0]
  def change
    change_table :demo_awards do |t|
      t.boolean :require_certification
    end

    change_table :demo_masteries do |t|
      t.boolean :require_certification
    end
  end
end