class CreateLoanAccountEditHistories < ActiveRecord::Migration[7.0]
  def change
    create_table :loan_account_edit_histories do |t|
      t.decimal :amount, precision: 12, scale: 2
      t.decimal :interest, precision: 5, scale: 2
      t.text :comment
      t.references :editor, null: true, foreign_key: { to_table: :users }
      t.references :loan_account, null: false, foreign_key: true
      t.integer :status

      t.timestamps
    end
  end
end
