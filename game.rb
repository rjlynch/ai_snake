class Game
  attr_reader :score, :game_over, :snake, :food, :board

  DIRECTIONS = {
    up: [-1, 0],
    down: [1, 0],
    right: [0, 1],
    left: [0, -1],
  }

  def initialize()
    @snake = [[5, 5]]
    @direction = [0, 1] # Initially moving right
    @food = [rand(10), rand(10)]
    @score = 0
    @game_over = false

    update_game_state
  end

  def play(display_callback:, move_callback:, game_over_callback:)
    while !@game_over
      display_callback.call(self)
      player_move = move_callback.call(self)
      @direction = DIRECTIONS.fetch(player_move)
      update_game_state
    end
    game_over_callback.call(self)
  end

  def game_over?
    @game_over
  end

  private

  def update_game_state
    new_position = [@snake.first[0] + @direction[0], @snake.first[1] + @direction[1]]
    if collision?(new_position)
      @game_over = true
      @board = Board.new(self)
      return
    end
    @snake.unshift(new_position)
    if new_position == @food
      @score += 1
      place_new_food
    else
      @snake.pop
    end

    @board = Board.new(self)
  end

  def collision?(position)
    position.any? { |coord| coord < 0 || coord >= 10 } || @snake.include?(position)
  end

  def place_new_food
    loop do
      @food = [rand(10), rand(10)]
      break unless @snake.include?(@food)
    end
  end
end

