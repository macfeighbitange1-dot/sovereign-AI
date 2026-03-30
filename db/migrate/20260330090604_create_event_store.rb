class CreateEventStore < ActiveRecord::Migration[7.0]
  def change
    # The Event Store: Where every financial "Fact" lives
    create_table :event_store_events, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.string      :event_type, null: false
      t.binary      :metadata
      t.binary      :data,       null: false
      t.datetime    :created_at, null: false, precision: 6
      t.datetime    :valid_at,   precision: 6
    end
    add_index :event_store_events, :created_at
    add_index :event_store_events, :event_type

    # The Stream: How we group events (e.g., "Wallet$1")
    create_table :event_store_events_in_streams, id: :serial do |t|
      t.string      :stream,     null: false
      t.integer     :position
      t.uuid        :event_id,   null: false
      t.datetime    :created_at, null: false, precision: 6
    end
    add_index :event_store_events_in_streams, [:stream, :position], unique: true
    add_index :event_store_events_in_streams, [:stream, :event_id], unique: true
  end
end
