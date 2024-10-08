class LoanPresenter < Struct.new(:record, :user)
  include Rails.application.routes.url_helpers
  extend Forwardable

  def_delegator :record, :amount
  def_delegator :record, :interest
  def_delegator :record, :status

  def created_at
    record.created_at.strftime("%d-%m-%Y, %H:%M")
  end

  def last_edit
    return if record.editor_id.nil?

    LoanHistoryPresenter.new(history.first)
  end

  def requested_by
    record.borrower.full_name
  end

  def history
    history ||= record.loan_account_edit_histories
  end

  def repay_amount
    record.total_amount
  end

  def actions
    next_actions = LoanAccount::PERMITTED_STATUS_CHANGES[record.status.to_sym]

    next_actions.map do |action|

      next nil if !LoanAccount::ACTOR[action.to_sym].include?(user_role) ||
        (record.requested? && record.borrower_id == user.id) || # just created
        (user.id == record.editor_id && action != :closed) # actions should not be visible to current editor

      {
        approved: { name: 'Approve', class: 'btn-success', path: loan_path(record) },
        rejected: { name: 'Reject', class: 'btn-danger', path: loan_path(action) },
        waiting_for_adjustment_acceptance: { name: 'Edit', class: 'btn-warning', path: edit_loan_path(record), method: :get },
        open: { name: 'Accept', class: 'btn-success', path: loan_path(record) },
        readjustment_requested: { name: 'Ask for Readjustment', class: 'btn-warning', path: loan_path(record) },
        closed: { name: 'Close', class: 'btn-success', path: loan_path(record) },
      }[action]
    end.compact
  end

  private

  def user_role
    user.admin? ? :admin : :borrower
  end
end
