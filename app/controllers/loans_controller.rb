class LoansController < ApplicationController
  before_action :set_loan, except: [:index, :new, :create]
  before_action :authorize_resource, except: [:index, :new, :create]
  before_action :set_loan_service, only: [:create, :update]

  def index
    @loans = LoanAccount.where(nil)
    @loans = @loans.where(status: params[:filter]) if params[:filter]
    @loans = @loans.where(borrower_id: current_user.id) if !current_user.admin?
  end

  def show
    @loan = LoanPresenter.new(@loan, current_user)
  end

  def new
    @loan = LoanAccount.new
  end

  def create
    authorize @service.account

    @service.call

    set_controller_create_message

    @loan = @service.account
    if @service.account.errors.present?
      render :new
      return
    end

    redirect_to loan_path(@loan)
  end

  def edit; end

  def update
    @service.call

    set_controller_update_message

    @loan = @service.account
    if @service.action == :update && @service.account.errors.present?
      render :edit
      return
    end

    redirect_to loan_path(@loan)
  end

  private

  def set_loan
    @loan = LoanAccount.find(params[:id])
  end

  def set_loan_service
    @service = LoanService.new(
                                account: (action_name == 'create' ? LoanAccount.new : @loan) ,
                                action: params[:commit].parameterize(separator: '_'),
                                actor: current_user,
                                params: loan_params
                              )
  end

  def set_controller_update_message
    if @service.account.errors.present?
      flash[:alert] = @service.errors
    else
      flash[:notice] = "Status changed to #{@service.account.status}"
    end
  end

  def set_controller_create_message
    if @service.account.errors.present?
      flash[:alert] = @service.errors
    else
      flash[:notice] = "Loan created and requested"
    end
  end

  def loan_params
    return {} unless params[:loan_account].present?

    if action_name == 'update'
      params.require(:loan_account).permit(:amount, :interest_percentage, :comment)
    else
      params.require(:loan_account).permit(:amount, :interest_percentage)
    end
  end

  def authorize_resource
    authorize @loan
  end
end
