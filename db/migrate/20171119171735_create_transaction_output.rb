class CreateTransactionOutput < ActiveRecord::Migration[5.0]
  def change
    create_table :transaction_outputs do |t|
      t.integer :transaction_id
      t.integer :address_id

      t.integer :output_index
      t.decimal :value, :limit => 8, :precision => 18, :scale => 8

      t.string :asm
      t.string :hex
      t.string :pub_key_type
      t.integer :req_sigs

      t.timestamps

      t.index :transaction_id
      t.index :address_id
    end
  end
end
