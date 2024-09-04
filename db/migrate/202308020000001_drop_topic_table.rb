class DropTopicTable < ActiveRecord::Migration[7.0]
  def change
    drop_table :demo_topics
  end
end