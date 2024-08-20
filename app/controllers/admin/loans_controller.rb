class Admin::LoansController < ApplicationController
  # before_action :authenticate_admin!
  before_action :set_loan, except: [:index]
  before_action :instantiate_service, only: [:approve, :reject, :update]

  def index
    @loans = params[:filter] ? LoanAccount.where(status: :params[:filter]) : LoanAccount.all
  end

  def show
    @loan = LoanPresenter.new(@loan, current_user)
  end

  def approve
    @service.call

    if @service.account.errors.empty?
      flash[:notice] = 'Appproved'
    else
      flash[:alert] = 'Something went wrong!'
    end

    redirect_to admin_loan_path(@service.account)
  end

  def reject
    @service.call

    if @service.account.errors.empty?
      flash[:notice] = 'Rejected'
    else
      flash[:alert] = 'Something went wrong!'
    end

    redirect_to admin_loan_path(@service.account)
  end

  def edit; end

  def update
    @service.call

    if @service.account.errors.empty?
      redirect_to admin_loan_path(@service.account), notice: 'Updated'
    else
      flash[:alert] = @service.errors
      render :edit
    end
  end

  private

  def set_loan
    @loan = LoanAccount.find(params[:id])
  end

  def instantiate_service
    @service = LoanService.new(
      account: @loan,
      action: action_name,
      actor: current_user,
      params: (action_name.to_sym == :update ? loan_params : nil)
    )
  end

  def loan_params
    params.require(:loan_account).permit(:amount, :interest_percentage, :comment)
  end
end
