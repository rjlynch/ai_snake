class Human
  def update_state(game)
    get_input
  end

  def game_over(game)
    # NOOP
  end

  def human?
    true
  end

  private

  def get_input
    input = read_char
    case input
    when "\e[A"
      :up
    when "\e[B"
      :down
    when "\e[C"
      :right
    when "\e[D"
      :left
    end
  end

  def read_char
    STDIN.echo = false
    STDIN.raw!

    input = STDIN.getc.chr
    if input == "\e" then
      input << STDIN.read_nonblock(3) rescue nil
      input << STDIN.read_nonblock(2) rescue nil
    end
  ensure
    STDIN.echo = true
    STDIN.cooked!

    return input
  end
end
