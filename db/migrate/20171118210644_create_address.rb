class CreateAddress < ActiveRecord::Migration[5.0]
  def change
    create_table :addresses do |t|
      t.string :address
      t.decimal :total_received, default: 0, :precision => 18, :scale => 8
      t.decimal :total_staked, default: 0, :precision => 18, :scale => 8
      t.decimal :total_spent, default: 0, :precision => 18, :scale => 8
      t.decimal :balance, default: 0, :precision => 18, :scale => 8

      t.boolean :is_locked_for_game, default: false

      t.timestamps

      t.index :balance
    end
  end
end
