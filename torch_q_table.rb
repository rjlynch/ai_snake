class TorchQTable < Torch::NN::Module
  class Memory < Struct.new(
    :board,
    :move,
    :reward,
    :outcome_board,
    keyword_init: true
  )
  end

  def initialize
    super()
    self.to(Torch.device("mps"))
    @input_layer = Torch::NN::Linear.new(16, 16)
    @hidden_layer = Torch::NN::Linear.new(16, 16)
    @output_layer = Torch::NN::Linear.new(16, 1)
    @activation_function = Torch::NN::ReLU.new
    @loss_fn = Torch::NN::MSELoss.new

    @training_runs = 0

    @memories = []
  end

  def reward_for(board:, move:)
    vector = InputVector.new(board: board, move: move)

    forward(Torch.tensor(vector.to_a, dtype: :float)).item
  end

  def learn(board:, move:, reward:, outcome_board:)
    if memory_full?
      batch = @memories.shuffle!.shift(HyperParameters::BATCH_SIZE)

      train(batch)
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
    @memories.size >= HyperParameters::MEMORY_SIZE
  end

  def train(batch)
    learning_rate = HyperParameters::LEARNING_RATE.call(@training_runs)

    foregtting_rate = (1 - learning_rate)

    discount_rate = HyperParameters::DISCOUNT

    optimizer = Torch::Optim::Adam.new(parameters, lr: learning_rate)

    # Train the model
    HyperParameters::NUM_EPOCHS.times do |epoch|
      x = []
      y = []

      batch.each do |memory|
        observed_reward = memory.reward

        estimate_of_optimal_future_reward = Agent::ACTIONS.map do |action|
          reward_for(board: memory.outcome_board, move: action)
        end.max

        total_reward = \
          observed_reward + (discount_rate * estimate_of_optimal_future_reward)

        learned_reward = reward_for(board: memory.board, move: memory.move)

        updated_q_value = \
          (foregtting_rate * learned_reward) + (learning_rate * total_reward)

        x.push(InputVector.new(board: memory.board, move: memory.move).to_a)

        y.push(updated_q_value)
      end

      inputs = Torch.tensor(x, dtype: :float)

      targets = Torch.tensor(y, dtype: :float).unsqueeze(1)

      # Forward pass
      pred = forward(inputs)

      # Compute loss
      loss = @loss_fn.call(pred, targets)

      # Backward and optimize
      optimizer.zero_grad
      loss.backward
      optimizer.step
    end


    @training_runs += 1
  end

  def forward(x)
    x = @activation_function.call(@input_layer.call(x))
    x = @activation_function.call(@hidden_layer.call(x))
    @output_layer.call(x)
  end
end
