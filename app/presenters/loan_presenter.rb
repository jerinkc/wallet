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
    history ||= [] || record.loan_account_edits.order_by(:desc)
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
        approved: { name: 'Approve', class: 'btn-success', path: approve_admin_loan_path(record) },
        rejected: { name: 'Reject', class: 'btn-danger', path: resource_path(action) },
        waiting_for_adjustment_acceptance: { name: 'Edit', class: 'btn-warning', path: edit_admin_loan_path(record), method: :get },
        open: { name: 'Accept', class: 'btn-success', path: accept_user_loan_path(record) },
        readjustment_requested: { name: 'Ask for adjustment', class: 'btn-warning', path: ask_readjustment_user_loan_path(record) },
        closed: { name: 'Close', class: 'btn-success', path: close_user_loan_path(record) }, #TODO: update path
      }[action]
    end.compact
  end

  private

  def resource_path(action)
    return unless action == :rejected

    user.admin? ? reject_admin_loan_path(record) : reject_user_loan_path(record)
  end

  def user_role
    user.admin? ? :admin : :borrower
  end
end
