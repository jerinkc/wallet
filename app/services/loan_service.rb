class LoanService
  attr_reader :account, :account_was, :action, :actor, :params, :errors

  def initialize(actor:, action:, account:, params: {})
    @actor = actor
    @params = params || {}
    @action = action.to_sym
    @account = account
  end

  def call
    LoanAccount.transaction do
      record_account_history
      build_account
      send(action)
    end
    rescue ActiveRecord::RecordInvalid => e
      @errors = e.message
  end

  private

  def create
    account.requested!
  end

  def update
    return unless account.values_changed?

    account.waiting_for_adjustment_acceptance!
  end

  def approve
    account.approved!
  end

  def reject
    account.rejected!
  end

  def ask_for_readjustment
    account.readjustment_requested!
  end

  # or confirm
  def accept
    WalletService.new(
      to: account.borrower.wallet_account,
      amount: account.amount
    ).transfer!
    account.open!
  end

  def close
    # deduct_from_loan_account
    wallet_account = WalletService.new(
      from: account.borrower.wallet_account,
      amount: account.amount
    ).transfer!
    account.closed!
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

  # def deduct_from_loan_account
  #   user_wallet_account_balance = account.borrower.wallet_account.balance
  #   loan_amount = account.total_amount
  #   after_deduct_loan_amount = loan_amount - user_wallet_account_balance

  #   if after_deduct_loan_amount <= 0
  #     account.assign_attributes(total_amount: 0)
  #   else
  #     account.assign_attributes(total_amount: after_deduct_loan_amount)
  #   end
  # end
end
