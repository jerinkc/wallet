class User::LoansController < ApplicationController
  # before_action :authenticate_user!
  before_action :set_loan, except: [:index, :new, :create]
  before_action :instantiate_service, except: [:index, :show, :new]

  def index
    @loans = params[:filter] ? LoanAccount.where(status: :params[:filter]) : current_user.loan_accounts
  end

  def show
    @loan = LoanPresenter.new(@loan, current_user)
  end

  def new
    @loan = LoanAccount.new
  end

  def create
    @service.call
    @loan = @service.account
byebug
    if @service.account.errors.empty?
      redirect_to user_loan_path(@loan), notice: 'Created'
    else
      flash[:alert] = @service.errors
      render :new
    end
  end

  def accept
    @service.call

    if @service.account.errors.empty?
      flash[:notice] = 'Accepted'
    else
      flash[:alert] = 'Something went wrong!'
    end

    redirect_to user_loan_path(@service.account)
  end

  def reject
    @service.call

    if @service.account.errors.empty?
      flash[:notice] = 'Rejected'
    else
      flash[:alert] = 'Something went wrong!'
    end

    redirect_to user_loan_path(@service.account)
  end

  def ask_readjustment
    @service.call

    if @service.account.errors.empty?
      flash[:notice] = 'Requested'
    else
      flash[:alert] = 'Something went wrong!'
    end

    redirect_to user_loan_path(@service.account)
  end

  private

  def set_loan
    @loan = LoanAccount.find(params[:id])
  end

  def instantiate_service
    if action_name.to_sym == :create
      @service = LoanService.new(
        account: LoanAccount.new,
        action: action_name,
        actor: current_user,
        params: loan_params
      )
    else
      @service = LoanService.new(
        account: @loan,
        action: action_name,
        actor: current_user
      )
    end

  end

  def loan_params
    params.require(:loan_account).permit(:amount, :interest_percentage, :comment)
  end
end
