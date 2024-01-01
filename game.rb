class Game
  attr_reader :score, :game_over, :snake, :food, :board, :number_of_rounds

  DIRECTIONS = {
    up: [-1, 0],
    down: [1, 0],
    right: [0, 1],
    left: [0, -1],
  }

  def initialize(agent:, display:, number_of_rounds:)
    @snake = [[5, 5]]
    @direction = [0, 1] # Initially moving right
    @food = [rand(10), rand(10)]
    @score = 0
    @game_over = false
    @agent = agent
    @display = display
    @number_of_rounds = number_of_rounds

    update_game_state
  end

  def play
    while !@game_over
      @display.show(game: self, agent: @agent)
      player_move = @agent.update_state(self)
      @direction = DIRECTIONS.fetch(player_move)
      update_game_state
    end
    @agent.game_over(self)
    @display.game_over(self)
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

