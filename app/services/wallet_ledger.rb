class WalletLedger
  def self.balance_for(wallet_id)
    stream_name = "Wallet$#{wallet_id}"
    events = Rails.configuration.event_store.read.stream(stream_name).to_a
    
    events.reduce(0) do |balance, event|
      case event
      when Wallet::MoneyDeposited
        balance + event.data[:amount]
      when Wallet::MoneyWithdrawn
        balance - event.data[:amount]
      else
        balance
      end
    end
  end
end
