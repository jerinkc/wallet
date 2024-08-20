class WalletService
  class LimitExceededError < StandardError; end

  attr_accessor :from, :to, :amount

  def initialize(amount:, from: nil, to: nil)
    @from = from || Admin.record.wallet_account
    @to = to || Admin.record.wallet_account
    @amount = amount
  end

  def transfer!
    LoanAccount.transaction do
      deduct_from_account
      credit_to_account
      raise LimitExceededError if admin_wallet_exceeded?
    end
  end

  private

  def deduct_from_account
    remaining = from.balance - amount
    from.update!(balance: remaining)
  end

  def credit_to_account
    new_balance = to.balance + amount
    to.update!(balance: new_balance)
  end

  def admin_wallet_exceeded?
    from.user.admin? && from.balance < 0
  end
end
