class LoanAccountEditHistory < ApplicationRecord
  include Loan::Stateful

  belongs_to :loan_account
  belongs_to :editor, class_name: 'User', foreign_key: 'editor_id', optional: true

  validates :amount, :interest, presence: true
end
