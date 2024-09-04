class RenameColumn < ActiveRecord::Migration[7.0]
  def change
    change_table :demo_accounts do |t|
      t.remove :type
      t.string :account_type
    end
  end
end