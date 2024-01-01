class HyperParameters
  LEARNING_RATE = -> (num_training_runs) { 0.001 }
  MEMORY_SIZE = 50
  BATCH_SIZE = 40
  NUM_EPOCHS = 5
  DISCOUNT = 0.9

  INTIAL_EPSILON = 400
  MINIMUM_EPSILON = 5

  EPSILON_CALLBACK = ->(number_of_games) do
    return 0 if number_of_games > 5000

    [(INTIAL_EPSILON - number_of_games), MINIMUM_EPSILON].max
  end

  REWARD_FOOD = 1
  REWARD_GAME_OVER = -1
  REWARD_MOVE = -0.1

  NUM_GAMES = 6_000
  SHOW_DEBUG_DISPLAY = -> (itteration) { itteration > 5000 }
  SHOW_SIMPLE_DISPLAY = -> (itteration) { itteration % 10 == 0 }
end
