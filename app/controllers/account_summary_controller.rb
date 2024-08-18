class AccountSummaryController < ApplicationController
  def show
    @wallet = current_user.wallet_account
  end
end
