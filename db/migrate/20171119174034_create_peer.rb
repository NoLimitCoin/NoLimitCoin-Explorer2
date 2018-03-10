class CreatePeer < ActiveRecord::Migration[5.0]
  def change
    create_table :peers do |t|
      t.string :ip_address
      t.integer :port
      t.decimal :lat
      t.decimal :long
      t.string :country_code
      t.string :country
      t.string :city

      t.string :services
      t.integer :last_send
      t.integer :last_recv
      t.integer :conn_time
      t.integer :version
      t.string :sub_ver
      t.boolean :inbound
      t.integer :starting_height
      t.integer :ban_score

      t.timestamp

      t.index :ip_address
    end
  end
end