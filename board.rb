class Board
  attr_reader :cells, :snake_head, :snake_body, :food

  def initialize(game)
    @cells = Array.new(10) { Array.new(10) { :empty } }

    snake = game.snake

    @snake_head = snake.first

    snake_head_y = snake_head[0]

    snake_head_x = snake_head[1]

    @cells[snake_head_y][snake_head_x] = :head

    @snake_body = snake[1..-1]

    snake_body.each do |segment|
      segment_y = segment[0]

      segment_x = segment[1]

      @cells[segment_y][segment_x] = :body
    end

    @food = game.food

    food_y = food[0]

    food_x = food[1]

    @cells[food_y][food_x] = :food
  end
end
