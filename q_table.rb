class QTable
  class Memory < Struct.new(:board, :move, :reward, keyword_init: true)
  end

  def initialize
    @learning_rate = 1e-1
    @discount_factor = 0.9

    @table = {}

    vector = InputVector.new(board: Board.new(Game.new), move: :na)

    num_states = vector.to_a.size
    possible_states = 2 ** num_states

    possible_states.times do |i|
      state_key = i.to_s(2).rjust(num_states, '0').chars.map(&:to_i)
      @table[state_key] = rand(-0.1..0.1)
    end

    @memories = []
  end

  MEMORY_SIZE = 1000
  BATCH_SIZE = 750

  def reward_for(board:, move:)
    vector = InputVector.new(board: board, move: move)

    @table[vector.to_a]
  end

  def learn(board:, move:, reward:)
    if memory_full?
      batch = @memories.shift(BATCH_SIZE)

      batch.each do |memory|
        train(board: memory.board, move: memory.move, reward: memory.reward)
      end
    end

    @memories << Memory.new(board: board, move: move, reward: reward)
  end

  private

  def memory_full?
    @memories.size >= MEMORY_SIZE
  end

  def train(board:, move:, reward:)
    vector = InputVector.new(board: board, move: move)

    current_q_value = @table[vector.to_a]

    max_future_q_value = Agent::ACTIONS.map do |action|
      possible_next_state = InputVector.new(board: board, move: action)
      @table[possible_next_state.to_a]
    end.max

    new_q_value = current_q_value + @learning_rate * (reward + @discount_factor * max_future_q_value - current_q_value)

    @table[vector.to_a] = new_q_value
  end
end
