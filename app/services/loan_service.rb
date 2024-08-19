class LoanService
  attr_reader :account, :account_was, :action, :actor, :params, :errors

  def initialize(actor:, action:, account:, params: {})
    @actor = actor
    @params = params
    @action = action.to_sym
    @account = account
  end

  def call
    LoanAccount.transaction do
      record_account_history
      build_account
      send(action)
    end
  end

  private

  def create
    account.requested!
  end

  def update
    return unless values_updated?

    if actor.admin?
      account.waiting_for_adjustment_acceptance!
    else
      account.readjustment_requested!
    end
  end

  def approve
    account.approved!
  end

  def reject
    account.reject!
  end

  # or confirm
  def accept
    WalletService.transfer(
      from: Admin.wallet,
      to: account.borrower.wallet_account,
      amount: account.amount
    )
    account.open!
  end

  def close
    WalletService.transfer(
      from: account.borrower.wallet_account,
      to: Admin.wallet,
      amount: account.amount
    )
    account.close!
  end

  def record_account_history
    return if action == :create

    # LoanAccountHistory.create!(
    #   amount: account.amount,
    #   editor_id: account.editor_id,
    #   state: account.state,
    #   intrest:account.intrest
    # )
  end

  def values_updated?
    account.amount != params[:amount] || account.interest_percentage != params[:interest_percentage]
  end

  def build_account
    @account_was = account


    additional_params = if action == :create
                          { borrower: actor }
                        else
                          { editor: actor }
                        end

    params.merge!(additional_params)
    account.assign_attributes(params)
  end
end
