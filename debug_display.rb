class DebugDisplay
  def show(game:, agent:)
    system "clear"
    puts "itteration #{game.number_of_rounds}"
    puts "Score #{game.score}"

    game.board.cells.each do |row|
      row.each do |cell|
        case cell
        when :empty
          print "."
        when :head
          print "H"
        when :body
          print "B"
        when :food
          print "F"
        end
      end

      puts
    end

    sleep 0.1
  end

  def game_over(game)
    puts "Game Over! Your score: #{game.score}"
  end
end
