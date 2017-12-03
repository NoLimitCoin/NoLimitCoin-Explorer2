class CreateTransaction < ActiveRecord::Migration[5.0]
  def change
    create_table :transactions do |t|
      t.integer :block_id
      t.string :tx_hash
      t.string :block_hash

      t.integer :tx_type, default: 1
      t.decimal :stake_value, default: 0, :precision => 18, :scale => 8

      t.integer :confirmations
      t.integer :version
      t.integer :lock_time

      t.datetime :time

      t.timestamps

      t.index :tx_hash
      t.index :block_hash
      t.index :block_id
    end
  end
end
