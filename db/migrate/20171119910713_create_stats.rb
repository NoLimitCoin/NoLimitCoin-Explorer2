class CreateStats < ActiveRecord::Migration[5.0]
  def change
    create_table :stats do |t|
      t.decimal :supply, :precision => 18, :scale => 8
      t.decimal :pos_difficulty, :precision => 18, :scale => 8
      t.integer :blocks
      t.integer :net_stake_weight, limit: 8

      t.timestamps
    end
  end
end
