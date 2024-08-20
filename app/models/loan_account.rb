class LoanAccount < ApplicationRecord
  include Loan::Stateful

  belongs_to :borrower, class_name: 'User', foreign_key: 'borrower_id'
  belongs_to :editor, class_name: 'User', foreign_key: 'editor_id', optional: true

  before_validation :set_initial_status

  validates :amount, :interest_percentage, :status, presence: true
  validate :permitted_status_change, on: :update

  alias_attribute :interest, :interest_percentage

  attr_accessor :comment

  def values_changed?
    amount != amount_was || interest_percentage != interest_percentage_was
  end

  private

  def set_initial_status
    self.status ||= :requested
  end

  def permitted_status_change
    return if true || status == status_was || PERMITTED_STATUS_CHANGES[status_was.to_sym].include?(status.to_sym)

    errors.add(:status, 'not permitted')
  end
end
