class CreateTransactionInput < ActiveRecord::Migration[5.0]
  def change
    create_table :transaction_inputs do |t|
      t.integer :transaction_id
      t.integer :address_id
      t.integer :input_tx

      t.integer :output_index

      t.string :asm, length: 500
      t.string :hex, length: 500
      t.integer :sequence, limit: 8

      t.timestamps

      t.index :transaction_id
      t.index :address_id
      t.index :input_tx
    end
  end
end
