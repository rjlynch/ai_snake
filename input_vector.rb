class InputVector
  attr_reader :move

  def initialize(board:, move:)
    @board = board
    @move = move
    @wall_top = 0
    @wall_left = 0
    @wall_bottom = 9
    @wall_right = 9
  end

  def to_a
    [
      body_left?,
      body_right?,
      body_above?,
      body_below?,

      wall_left?,
      wall_right?,
      wall_above?,
      wall_below?,

      food_left?,
      food_right?,
      food_above?,
      food_below?,

      move_left?,
      move_right?,
      move_up?,
      move_down?
    ].map { |bool| bool ? 1 : 0 }
  end

  private

  def body_left?
    body_segments.any? do |segment|
      head_directly_left_of?(segment)
    end
  end

  def body_right?
    body_segments.any? do |segment|
      head_directly_right_of?(segment)
    end
  end

  def body_above?
    body_segments.any? do |segment|
      head_directly_above?(segment)
    end
  end

  def body_below?
    body_segments.any? do |segment|
      head_directly_below?(segment)
    end
  end

  def wall_left?
    head_x == @wall_left
  end

  def wall_right?
    head_x == @wall_right
  end

  def wall_above?
    head_y == @wall_top
  end

  def wall_below?
    head_y == @wall_bottom
  end

  def food_left?
    food_x < head_x
  end

  def food_right?
    food_x > head_x
  end

  def food_above?
    food_y < head_y
  end

  def food_below?
    food_y > head_y
  end

  def move_left?
    @move == :left
  end

  def move_right?
    @move == :right
  end

  def move_up?
    @move == :up
  end

  def move_down?
    @move == :down
  end

  def head_directly_left_of?(coord)
    coord_y, coord_x = coord

    head_y == coord_y && head_x == coord_x - 1
  end

  def head_directly_right_of?(coord)
    coord_y, coord_x = coord

    head_y == coord_y && head_x == coord_x + 1
  end

  def head_directly_above?(coord)
    coord_y, coord_x = coord

    head_y == coord_y - 1 && head_x == coord_x
  end

  def head_directly_below?(coord)
    coord_y, coord_x = coord

    head_y == coord_y + 1 && head_x == coord_x
  end

  def head
    @board.snake_head
  end

  def head_y
    head[0]
  end

  def head_x
    head[1]
  end

  def body_segments
    @board.snake_body
  end

  def food
    @board.food
  end

  def food_y
    food[0]
  end

  def food_x
    food[1]
  end
end
