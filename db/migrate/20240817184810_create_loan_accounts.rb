class CreateLoanAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :loan_accounts do |t|
      t.decimal :amount, precision: 12, scale: 2
      t.decimal :interest_percentage, precision: 5, scale: 2
      t.decimal :total_amount, precision: 12, scale: 2
      t.references :borrower, null: false, foreign_key: { to_table: :users }
      t.references :editor, null: true, foreign_key: { to_table: :users }
      t.integer :status, null: false

      t.timestamps
    end
  end
end
