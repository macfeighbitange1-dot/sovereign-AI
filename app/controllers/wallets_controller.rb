class WalletsController < ActionController::Base
  # Protect from CSRF for browser forms, but skip for API calls
  protect_from_forgery with: :exception, unless: -> { request.format.json? }

  # GET /wallets/:id
  # The UI Dashboard: Shows the Balance and the Audit Trail
  def show
    @balance = WalletLedger.balance_for(params[:id])
    @history = WalletAuditor.history_for(params[:id]).reverse # Newest first for UI
  end

  # GET /wallets/:id/balance
  # API Query: Current state for the AI Agent
  def balance
    balance = WalletLedger.balance_for(params[:id])
    render json: { 
      wallet_id: params[:id], 
      balance: balance, 
      currency: "KES" 
    }
  end

  # GET /wallets/:id/history
  # API Query: Full event replay
  def history
    audit_log = WalletAuditor.history_for(params[:id])
    render json: { 
      wallet_id: params[:id], 
      transactions: audit_log 
    }
  end

  # POST /wallets/:id/deposit
  def deposit
    DepositMoney.call(params[:id], params[:amount].to_i)
    
    respond_to do |format|
      format.json { render json: { status: "success" }, status: :created }
      format.html { redirect_to wallet_path(params[:id]), notice: "Deposit successful" }
    end
  rescue => e
    handle_error(e)
  end

  # POST /wallets/:id/withdraw
  def withdraw
    WithdrawMoney.call(params[:id], params[:amount].to_i)
    
    respond_to do |format|
      format.json { render json: { status: "success" }, status: :ok }
      format.html { redirect_to wallet_path(params[:id]), notice: "Withdrawal successful" }
    end
  rescue WithdrawMoney::InsufficientFunds => e
    handle_error(e, :payment_required)
  rescue => e
    handle_error(e)
  end

  private

  def handle_error(exception, status = :unprocessable_entity)
    respond_to do |format|
      format.json { render json: { status: "error", message: exception.message }, status: status }
      format.html { redirect_to wallet_path(params[:id]), alert: exception.message }
    end
  end
end
