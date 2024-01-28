class QTable
  class Memory < Struct.new(
    :board,
    :move,
    :reward,
    :outcome_board,
    keyword_init: true,
  )
  end

  def initialize
    @learning_rate = 1e-1
    @discount_factor = 0.9

    @table = {}

    vector = InputVector.new(
      board: Board.new(
        Game.new(
          agent: :null,
          display: :null,
          number_of_rounds: :null,
        ),
      ),
      move: :na,
    )

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

  def learn(board:, move:, reward:, outcome_board:)
    if memory_full?
      batch = @memories.shift(BATCH_SIZE)

      batch.each do |memory|
        train(
          board: memory.board,
          move: memory.move,
          reward: memory.reward,
          outcome_board: memory.outcome_board,
        )
      end
    end

    @memories << Memory.new(
      board: board,
      move: move,
      reward: reward,
      outcome_board: outcome_board,
    )
  end

  private

  def memory_full?
    @memories.size >= MEMORY_SIZE
  end

  def train(board:, move:, reward:, outcome_board:)
    learning_rate = @learning_rate

    discount_rate = @discount_factor

    foregtting_rate = (1 - learning_rate)

    observed_reward = reward

    estimate_of_optimal_future_reward = Agent::ACTIONS.map do |action|
      reward_for(board: outcome_board, move: action)
    end.max

    total_reward = \
      observed_reward + (discount_rate * estimate_of_optimal_future_reward)

    learned_reward = reward_for(board: board, move: move)

    updated_q_value = \
      (foregtting_rate * learned_reward) + (learning_rate * total_reward)

    vector = InputVector.new(board: board, move: move)

    @table[vector.to_a] = updated_q_value
  end
end
