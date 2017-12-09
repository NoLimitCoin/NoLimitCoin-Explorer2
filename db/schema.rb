# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20171119910713) do

  create_table "addresses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "address"
    t.decimal  "total_received",     precision: 18, scale: 8, default: "0.0"
    t.decimal  "total_staked",       precision: 18, scale: 8, default: "0.0"
    t.decimal  "total_spent",        precision: 18, scale: 8, default: "0.0"
    t.decimal  "balance",            precision: 18, scale: 8, default: "0.0"
    t.boolean  "is_locked_for_game",                          default: false
    t.datetime "created_at",                                                  null: false
    t.datetime "updated_at",                                                  null: false
    t.index ["balance"], name: "index_addresses_on_balance", using: :btree
  end

  create_table "blocks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "block_index"
    t.string   "block_hash"
    t.string   "previous_block_hash"
    t.string   "next_block_hash"
    t.string   "merkle_root"
    t.string   "proof_hash"
    t.string   "modifier"
    t.string   "modifier_checksum"
    t.string   "signature"
    t.integer  "confirmations"
    t.integer  "size"
    t.integer  "height"
    t.integer  "version"
    t.bigint   "nonce"
    t.float    "difficulty",          limit: 24
    t.float    "mint",                limit: 24
    t.string   "bits"
    t.string   "block_trust"
    t.string   "chain_trust"
    t.string   "flags"
    t.string   "entropy_bit"
    t.datetime "time"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.index ["block_hash"], name: "index_blocks_on_block_hash", using: :btree
    t.index ["block_index"], name: "index_blocks_on_block_index", using: :btree
  end

  create_table "peers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string  "ip_address"
    t.integer "port"
    t.decimal "lat",             precision: 10
    t.decimal "long",            precision: 10
    t.string  "country_code"
    t.string  "country"
    t.string  "city"
    t.string  "services"
    t.integer "last_send"
    t.integer "last_recv"
    t.integer "conn_time"
    t.integer "version"
    t.string  "sub_ver"
    t.boolean "inbound"
    t.integer "starting_height"
    t.integer "ban_score"
    t.index ["ip_address"], name: "index_peers_on_ip_address", using: :btree
  end

  create_table "stats", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.decimal  "supply",           precision: 18, scale: 8
    t.decimal  "pos_difficulty",   precision: 18, scale: 8
    t.integer  "blocks"
    t.bigint   "net_stake_weight"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  create_table "transaction_inputs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "transaction_id"
    t.integer  "address_id"
    t.integer  "input_tx"
    t.integer  "output_index"
    t.string   "asm"
    t.string   "hex"
    t.bigint   "sequence"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["address_id"], name: "index_transaction_inputs_on_address_id", using: :btree
    t.index ["input_tx"], name: "index_transaction_inputs_on_input_tx", using: :btree
    t.index ["transaction_id"], name: "index_transaction_inputs_on_transaction_id", using: :btree
  end

  create_table "transaction_outputs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "transaction_id"
    t.integer  "address_id"
    t.integer  "output_index"
    t.decimal  "value",          precision: 18, scale: 8
    t.string   "asm"
    t.string   "hex"
    t.string   "pub_key_type"
    t.integer  "req_sigs"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.index ["address_id"], name: "index_transaction_outputs_on_address_id", using: :btree
    t.index ["transaction_id"], name: "index_transaction_outputs_on_transaction_id", using: :btree
  end

  create_table "transactions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "block_id"
    t.string   "tx_hash"
    t.string   "block_hash"
    t.string   "stake_address"
    t.integer  "tx_type",                                default: 1
    t.decimal  "stake_value",   precision: 18, scale: 8, default: "0.0"
    t.integer  "confirmations"
    t.integer  "version"
    t.integer  "lock_time"
    t.datetime "time"
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
    t.index ["block_hash"], name: "index_transactions_on_block_hash", using: :btree
    t.index ["block_id"], name: "index_transactions_on_block_id", using: :btree
    t.index ["tx_hash"], name: "index_transactions_on_tx_hash", using: :btree
  end

end
