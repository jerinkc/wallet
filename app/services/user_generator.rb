class UserGenerator < Struct.new(:params)
  attr_reader :user, :errors

  def generate
    begin
      User.transaction do
        create_user!
        create_wallet_account!
      end
      rescue ActiveRecord::RecordInvalid => e
        @errors = e.message
    end

    @user.presence
  end

  private

  def create_user!
    @user = User.new(params)
    @user.save!
  end

  def create_wallet_account!
    wallet_initial_balance = params[:admin] ? 1_000_000 : 10_000
    @user.create_wallet_account!(balance: wallet_initial_balance)
  end
end
