class LoanAccountPolicy
  attr_reader :user, :account

  def initialize(user, account)
    @user = user
    @account = account
  end

  def create?
    !user.admin?
  end

  def show?
    user.admin? || user.id == account.borrower_id
  end

  def edit?
    user.admin? && requested_or_readjustment_requested?
  end

  def update?
    if user.admin?
      requested_or_readjustment_requested?
    else
      waiting_for_adjustment_acceptance_or_open? && user_is_borrower?
    end
  end

  private

  def requested_or_readjustment_requested?
    [:requested, :readjustment_requested].include?(account.status.to_sym)
  end

  def waiting_for_adjustment_acceptance_or_open?
    [:waiting_for_adjustment_acceptance, :open].include?(account.status.to_sym)
  end

  def user_is_borrower?
    account.borrower_id == user.id
  end
end
