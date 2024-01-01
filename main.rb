require "io/console"
require "byebug"
require "timeout"
require "torch-rb"
require_relative "hyper_parameters"
require_relative "board"
require_relative "q_table"
require_relative "input_vector"
require_relative "torch_q_table"
require_relative "human"
require_relative "agent"
require_relative "game"
require_relative "null_display"
require_relative "simple_display"
require_relative "debug_display"

def play
  display = DebugDisplay.new
  agent = Human.new
  game = Game.new(agent: agent, display: display, number_of_rounds: 0)

  game.play
end

def train_torch
  agent = Agent.new(TorchQTable.new)
  train(agent)
end

def train_memory
  agent = Agent.new(QTable.new)
  train(agent)
end

def train(agent)
  real_display = DebugDisplay.new
  simple_display = SimpleDisplay.new
  null_display = NullDisplay.new

  HyperParameters::NUM_GAMES.times do |itteration|
    if HyperParameters::SHOW_DEBUG_DISPLAY.call(itteration)
      display = real_display
    elsif HyperParameters::SHOW_SIMPLE_DISPLAY.call(itteration)
      display = simple_display
    else
      display = null_display
    end

    game = Game.new(agent: agent, display: display, number_of_rounds: itteration)

    begin
      Timeout::timeout(60) do
        game.play
      end
    rescue Timeout::Error
    end
  end
end

case ARGV[0]
when "play"
  play
when "agent"
  train_torch
when "q_table"
  train_memory
else
  puts "Usage: ruby main.rb play|train"
end
