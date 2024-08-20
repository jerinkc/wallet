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

  def actions
    next_actions = LoanAccount::PERMITTED_STATUS_CHANGES[record.status.to_sym]

    next_actions.map do |action|
      next nil if !LoanAccount::ACTOR[action.to_sym].include?(user_role) ||
        user.id == record.editor_id

      {
        approved: { name: 'Approve', class: 'btn-success', path: approve_admin_loan_path(record) },
        rejected: { name: 'Reject', class: 'btn-danger', path: resource_path(action) },
        waiting_for_adjustment_acceptance: { name: 'Edit', class: 'btn-warning', path: edit_admin_loan_path(record), method: :get },
        open: { name: 'Confirm', class: 'btn-success', path: '' || confirm_user_loan_path(record) },
        readjustment_requested: { name: 'Edit', class: 'btn-warning', path: '' || edit_user_loan_path(record) },
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
