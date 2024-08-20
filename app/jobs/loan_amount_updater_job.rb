class LoanAmountUpdaterJob
  include Sidekiq::Job

  def perform
    LoanAccount.includes(borrower: :wallet_account).where(status: :open).each do |account|
      recalculate_total_amount(account)
    end
  end

  private

  def recalculate_total_amount(account)
    interest_amount = (account.amount * account.interest)/100
    repay_amount = (account.total_amount || 0) + interest_amount
    account.update!(total_amount: repay_amount)

    return if repay_amount < account.borrower.wallet_account.balance

    LoanAccountService.new(
      actor: Admin.record,
      action: :close,
      account:,
    ).call
  end
end
