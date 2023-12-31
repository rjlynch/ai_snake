class Agent
  ACTIONS = %i(up down left right)
  attr_reader :previous_move

  def initialize(q_table)
    @first_move = true
    @number_of_moves = 0
    @total_reward = 0
    @q_table = q_table
  end

  def update_state(game, itteration)
    @itteration = itteration

    if @first_move
      @first_move = false
    else
      # 5.) Obeserve the reward for the previous action
      score_after_previous_move = game.score

      reward = calculate_reward(
        current_score: score_after_previous_move,
        previous_score: @previous_score,
        game_over: game.game_over?
      )

      @total_reward += reward

      # 6.) Learn the result of that move
      learn(
        board: @previous_board,
        move: @previous_move,
        reward: reward,
      )
    end

    # 1.) Observe the current state
    score = game.score
    board = game.board

    # 2.) pick move with highest expected reward
    move = get_move(game)

    # 3.) Record current state for future learning
    @previous_score = score
    @previous_board = board
    @previous_move = move

    # 4.) return move to game
    move
  end

  def game_over(game, itteration)
    @number_of_moves += 1
    update_state(game, itteration)
  end

  def human?
    false
  end

  def epsilon
    HyperParameters::EPSILON_CALLBACK.call(@itteration)
  end

  def total_reward
    @total_reward
  end

  private

  def calculate_reward(current_score:, previous_score:, game_over:)
    if current_score > previous_score
      HyperParameters::REWARD_FOOD
    elsif game_over
      HyperParameters::REWARD_GAME_OVER
    else
      HyperParameters::REWARD_MOVE
    end
  end

  def get_move(game)
    if choose_random_move?
      random_move
    else
      get_best_move(game)
    end
  end

  def choose_random_move?
    rand(1..100) < epsilon
  end

  def random_move
    ACTIONS.sample
  end

  def get_best_move(game)
    ACTIONS.map do |action|
      [
        action,
        @q_table.reward_for(board: game.board, move: action)
      ]
    end.max_by(&:last).first
  end

  def learn(board:, move:, reward:)
    @q_table.learn(board: board, move: move, reward: reward)
  end
end
