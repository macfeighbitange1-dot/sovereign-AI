class WalletAuditor
  def self.history_for(wallet_id)
    stream_name = "Wallet$#{wallet_id}"
    
    # Read all events from the beginning (forward)
    events = Rails.configuration.event_store.read.stream(stream_name).forward.to_a

    # Map the events into a clean, human-readable array
    events.map do |event|
      {
        timestamp: event.metadata[:timestamp] || event.created_at,
        event_type: event.event_type.split('::').last, # e.json vs Wallet::MoneyDeposited
        amount: event.data[:amount],
        event_id: event.event_id
      }
    end
  end
end
