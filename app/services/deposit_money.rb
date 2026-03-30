class DepositMoney
  def self.call(wallet_id, amount)
    # Using the global event_store we defined in the initializer
    event_store = Rails.configuration.event_store
    stream_name = "Wallet$#{wallet_id}"

    # Construct the event with simple data
    event = Wallet::MoneyDeposited.new(data: { 
      amount: amount.to_i, 
      wallet_id: wallet_id.to_s 
    })

    # This is the line that writes to PostgreSQL
    event_store.publish(event, stream_name: stream_name)
    
    puts "Nairobi Node: Fact successfully appended to #{stream_name}"
  end
end
