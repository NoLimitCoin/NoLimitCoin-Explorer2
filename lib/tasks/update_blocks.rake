namespace :blocks do

  desc "Updates blocks, transactions and addresses"
  task update: :environment do
    new_block_index = Block.order(block_index: :desc).limit(1).pluck(:block_index).first || -1
    blockcount = RpcService.make_rpc('getblockcount')

    begin

      for i in new_block_index+1..blockcount-1
        puts "Updating block #{i}"
        update_block(i)
      end

    rescue Exception => e
      puts e.message
      puts e.backtrace
    end
  end

  private

  # Adds the block into database
  #
  # Author:: Sambhav Sharma
  # Date:: 20/11/2017
  #
  # Params:
  # +index+:: index of the block to be added
  #
  def update_block(index)
    Block.transaction do
      block_hash =  RpcService.make_rpc('getblockhash', [index])
      block_data = RpcService.make_rpc('getblock', [block_hash])

      # fetch the block with index, and if the block exists, then skip creating this block
      block = Block.find_by(block_index: index)
      return if block.present?

      block = Block.create!({
        block_index: index,
        block_hash: block_data["hash"],
        previous_block_hash: block_data["previousblockhash"],
        next_block_hash: block_data["nextblockhash"],
        merkle_root: block_data["merkleroot"],
        proof_hash: block_data["proofhash"],
        modifier: block_data["modifier"],
        modifier_checksum: block_data["modifierchecksum"],
        signature: block_data["signature"],
        confirmations: block_data["confirmations"],
        size: block_data["size"],
        height: block_data["height"],
        version: block_data["version"],
        nonce: block_data["nonce"],
        difficulty: block_data["difficulty"],
        mint: block_data["mint"],
        bits: block_data["bits"],
        block_trust: block_data["blocktrust"],
        chain_trust: block_data["chaintrust"],
        flags: block_data["flags"],
        entropy_bit: block_data["entropybit"],
        time: Time.at(block_data["time"])
      })

      if block.height > 0
        block_data["tx"].each do |tx_hash|
          update_tx(tx_hash, block.id)
        end
      end
    end
  end

  # Adds a transaction into the database
  #
  # Author:: Sambhav Sharma
  # Date:: 20/11/2017
  #
  # Params:
  # +tx_hash+:: hash of the transaction
  # +block_id+:: id of the transactions block
  #
  def update_tx(tx_hash, block_id)

    # fetch the transaction with hash, and if the transaction exists, then skip creating this transaction
    tx = Transaction.find_by(tx_hash: tx_hash)
    return if tx.present?

    tx_data = RpcService.make_rpc('gettransaction', [tx_hash])

    tx = Transaction.create!({
      block_id: block_id,
      tx_hash: tx_data["txid"],
      block_hash: tx_data["blockhash"],
      confirmations: tx_data["confirmations"],
      version: tx_data["version"],
      lock_time: tx_data["locktime"],
      time: Time.at(tx_data["time"])
    })

    inputs = tx_data["vin"]
    outputs  = tx_data["vout"]

    # Iterating over each output
    outputs.each do |output|
      upsert_addr_with_output(output, tx.id)
    end

    # Iterating over each input
    inputs.each do |input|
      update_addr_with_input(input, tx)
    end

    case tx.inputs.count
      when 0
        tx.tx_type = 'new_coins'
        tx.save
      when 1
        if tx.input_addresses == tx.output_addresses.uniq
          tx_input = tx.inputs.first
          ip_tx = Transaction.find(tx_input.input_tx)
          input_value = ip_tx.outputs.where(output_index: tx_input.output_index).collect(&:value).inject(&:+)
          output_value = tx.outputs.collect(&:value).inject(&:+)
          stake = output_value - input_value

          tx.tx_type = 'stake'
          tx.stake_value = stake
          tx.save

          addr = tx.input_addresses.first
          addr.total_received = addr.total_received - output_value + stake
          addr.total_spent = addr.total_spent - input_value
          addr.total_staked += stake
          addr.save
        end
      else
        # do nothing
    end
  end

  # Creates or updates addresses within an output
  #
  # Author:: Sambhav Sharma
  # Date:: 25/11/2017
  #
  # Params:
  # +output+:: output of a transaction
  # +tx_id+:: id of the transaction
  #
  def upsert_addr_with_output(output, tx_id)
    value = output["value"]
    # pulling out addresses for output
    o_addrs = output["scriptPubKey"]["addresses"]

    if o_addrs.present?
      o_addrs.try(:each) do |o_addr|
        addr = Address.find_or_initialize_by(address: o_addr)

        # check if this transaction was already added to the address
        # if addr.id
        #   return if TransactionAddress.where(address_id: addr.id, transaction_id: tx_id).count > 0
        # end

        # update address balances according to the transaction
        addr.balance = (addr.balance || 0.0) + value
        addr.total_received = (addr.total_received || 0.0) + value
        addr.save

        TransactionOutput.create!({
           transaction_id: tx_id,
           address_id: addr.id,
           value: value,
           output_index: output["n"],
           asm: output["scriptPubKey"]["asm"],
           hex:  output["scriptPubKey"]["hex"],
           req_sigs: output["scriptPubKey"]["reqSigs"],
           pub_key_type: output["scriptPubKey"]["type"]
        })
      end
    else
      # for outputs with no address
      TransactionOutput.create!({
         transaction_id: tx_id,
         value: value,
         output_index: output["n"],
         asm: output["scriptPubKey"]["asm"],
         hex:  output["scriptPubKey"]["hex"],
         req_sigs: output["scriptPubKey"]["reqSigs"],
         pub_key_type: output["scriptPubKey"]["type"]
       })
    end
  end

  # Updates addresses within an input
  #
  # Author:: Sambhav Sharma
  # Date:: 25/11/2017
  #
  # Params:
  # +input+:: input of a transaction
  # +tx+:: transaction
  #
  def update_addr_with_input(input, tx)
    input_tr = Transaction.find_by(tx_hash: input["txid"])
    if input_tr.present?
      input_tr_outputs =  input_tr.outputs.where(output_index: input["vout"])
      input_tr_outputs.each do |input_tr_output|

        addr = input_tr_output.output_address
        addr.total_spent += input_tr_output.value
        addr.balance -= input_tr_output.value
        addr.save

        TransactionInput.create!({
           transaction_id: tx.id,
           address_id: addr.id,
           input_tx: input_tr.id,
           output_index: input["vout"],
           asm: input["scriptSig"]["asm"],
           hex:  input["scriptSig"]["hex"],
           sequence: input["sequence"]
        })
      end
    end
  end

end
