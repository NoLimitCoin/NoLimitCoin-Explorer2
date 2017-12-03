class CreateBlock < ActiveRecord::Migration[5.0]
  def change
    create_table :blocks do |t|
      t.integer :block_index
      t.string :block_hash
      t.string :previous_block_hash
      t.string :next_block_hash
      t.string :merkle_root
      t.string :proof_hash
      t.string :modifier
      t.string :modifier_checksum
      t.string :signature

      t.integer :confirmations
      t.integer :size
      t.integer :height
      t.integer :version
      t.integer :nonce, :limit => 8
      t.float :difficulty
      t.float :mint


      t.string :bits
      t.string :block_trust
      t.string :chain_trust
      t.string :flags
      t.string :entropy_bit
      t.datetime :time

      t.timestamps

      t.index :block_index
      t.index :block_hash
    end
  end
end