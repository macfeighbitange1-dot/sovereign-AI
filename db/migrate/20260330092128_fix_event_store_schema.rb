class FixEventStoreSchema < ActiveRecord::Migration[7.0]
  def change
    # Drop the old tables to start fresh and clean
    drop_table :event_store_events_in_streams, if_exists: true
    drop_table :event_store_events, if_exists: true

    # 1. The Core Events Table
    create_table :event_store_events, id: false do |t|
      t.uuid      :id,         null: false, primary_key: true
      t.string    :event_type, null: false
      t.binary    :metadata
      t.binary    :data,       null: false
      t.datetime  :created_at, null: false, precision: 6
      t.datetime  :valid_at,               precision: 6
    end
    add_index :event_store_events, :created_at
    add_index :event_store_events, :event_type

    # 2. The Streams Mapping Table
    create_table :event_store_events_in_streams, id: :serial do |t|
      t.string    :stream,     null: false
      t.integer   :position
      t.uuid      :event_id,   null: false
      t.datetime  :created_at, null: false, precision: 6
    end
    add_index :event_store_events_in_streams, [:stream, :position], unique: true
    add_index :event_store_events_in_streams, [:stream, :event_id], unique: true
    add_index :event_store_events_in_streams, :created_at
  end
end
