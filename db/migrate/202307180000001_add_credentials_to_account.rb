class AddCredentialsToAccount < ActiveRecord::Migration[7.0]
  def change
    change_table :demo_accounts do |t|
      t.string :credentials
    end
  end
end