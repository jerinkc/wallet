class LoanAccount < ApplicationRecord
  include Loan::Stateful

  belongs_to :borrower, class_name: 'User', foreign_key: 'borrower_id'
  belongs_to :editor, class_name: 'User', foreign_key: 'editor_id', optional: true

  before_validation :set_initial_status

  validates :amount, :interest_percentage, :status, presence: true
  validate :permitted_status_change

  private

  def set_initial_status
    self.status ||= :requested
  end

  def permitted_status_change
    return if status_was.nil? || PERMITTED_STATUS_CHANGE[status.to_sym].include?(status_was.to_sym)

    errors.add(:status, 'not permitted')
  end
end
