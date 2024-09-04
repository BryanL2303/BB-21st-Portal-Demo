class CreateUniformInspectionTables < ActiveRecord::Migration[7.0]
  def change
    create_table :demo_uniform_components do |t|
      t.string :component_name
      t.integer :total_score

      t.timestamps
    end

    create_table :demo_component_fields do |t|
      t.belongs_to :demo_uniform_component
      t.string :description
      t.integer :score

      t.timestamps
    end

    create_table :demo_uniform_inspections do |t|
      t.belongs_to :demo_account
      t.integer :total_score
      t.string :date
      t.integer :assessor_id

      t.timestamps
    end

    create_table :demo_selected_components do |t|
      t.belongs_to :demo_uniform_inspection
      t.belongs_to :demo_component_field

      t.timestamps
    end
  end
end