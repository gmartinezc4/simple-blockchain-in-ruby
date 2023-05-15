class Block
  attr_reader :index, :timestamp, :transactions,
              :transactions_count, :previous_previous_hash,
              :previous_hash, :nonce, :hash

  def initialize(index, transactions, previous_hash, previous_previous_hash)
    @index                = index
    @timestamp            = Time.now
    @transactions         = transactions
    @transactions_count   = transactions.size
    @previous_hash        = previous_hash
    @previous_previous_hash = previous_previous_hash
    @nonce, @hash = compute_hash_with_proof_of_work
  end

  def compute_hash_with_proof_of_work(difficulty = '00')
    nonce = 0
    loop do
      hash = calculate_hash_with_nonce(nonce)
      if hash[0..1] == difficulty
        return [nonce, hash]
      else
        nonce += 1
      end
    end
  end

  def calculate_hash_with_nonce(nonce = 0)
    sha = Digest::SHA256.new
    sha.update(nonce.to_s + timestamp.to_s + transactions.to_s +
                transactions_count.to_s + previous_hash + previous_previous_hash)
    sha.hexdigest
  end

  def self.first(*transactions)
    Block.new(0, transactions, '0', '0')
  end

  def self.next(previous_block, *transactions)
    Block.new(previous_block.index + 1, transactions, previous_block.hash,
              previous_block.previous_hash)
  end
end  # class Block
