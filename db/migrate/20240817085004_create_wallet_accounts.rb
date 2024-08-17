class CreateWalletAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :wallet_accounts do |t|
      t.decimal :balance, null: false, default: 0, precision: 15, scale: 2
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
