require "rails_event_store"
require "arkency/command_bus"

# This force-configures the Active Record mapping
require "ruby_event_store/active_record"

Rails.configuration.to_prepare do
  repository = RubyEventStore::ActiveRecord::EventRepository.new(serializer: RubyEventStore::Serializers::YAML)
  
  Rails.configuration.event_store = RailsEventStore::Client.new(repository: repository)
  Rails.configuration.command_bus = Arkency::CommandBus.new
end
