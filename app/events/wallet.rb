# app/events/wallet.rb
module Wallet
  class MoneyDeposited < RailsEventStore::Event; end
  class MoneyWithdrawn < RailsEventStore::Event; end
end
