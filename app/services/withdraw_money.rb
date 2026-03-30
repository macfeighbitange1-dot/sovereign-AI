class WithdrawMoney
  class InsufficientFunds < StandardError; end

  def self.call(wallet_id, amount)
    event_store = Rails.configuration.event_store
    stream_name = "Wallet$#{wallet_id}"

    # 1. Check the Current Truth (The Replay)
    current_balance = WalletLedger.balance_for(wallet_id)

    # 2. Guard Clause: Prevent Negative Balance
    if current_balance < amount
      raise InsufficientFunds, "Nairobi Node: Transaction Rejected. Balance (#{current_balance}) is less than requested (#{amount})."
    end

    # 3. If Valid, Append the Withdrawal Fact
    event = Wallet::MoneyWithdrawn.new(data: { 
      amount: amount.to_i, 
      wallet_id: wallet_id.to_s 
    })

    event_store.publish(event, stream_name: stream_name)
    puts "Success: Withdrew #{amount} KES from #{stream_name}"
  end
end
