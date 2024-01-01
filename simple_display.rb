class SimpleDisplay
  def show(game:, agent:)
    itteration = game.number_of_rounds

    if @itteration_was != itteration
      #system "clear"
      puts "itteration #{itteration}"
      puts "Total reward #{agent.total_reward}"
      puts "Reward / game #{agent.total_reward.to_f / itteration.to_f}"
      puts
      puts
    end
    @itteration_was = itteration
  end

  def game_over(score)
  end
end
