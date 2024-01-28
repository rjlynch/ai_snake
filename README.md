  # Snake game and a neural net that learns to play it

  Neural net built with torch rb that plays snake

  Make sure [torch.rb](https://github.com/ankane/torch.rb) is installed.

  To play snake as a human run

  ```
  bundle exec ruby main.rb play
  ```

  To train a neural net to play snake run

  ```
  bundle exec ruby main.rb agent
  ```

  To train a q table (ruby hash) to play snake run

  ```
  bundle exec ruby main.rb q_table
  ```

  The agent uses a q learning based approach to learn the game, backed by
  either an in memory q table or a neural net modeling a q table depending
  on how it's configured.

  The `q_table` agent is backed by a simple ruby hash that learns to play the
  game.

  The `agent` agent is backed by a deep q table, where a torchrb neural net
  learns to model the q table.

  The `q_table` agent trains much faster!


  The action kicks off in the file `main.rb` so best to review that first.
  Hyper parameters can be tweaked in `hyper_parameters.rb`

  Still some cleaning up to do before this repo can be used as a reference but
  hopefully it's a decent place to get you started if you're interested in this
  sort of thing.

  ## Hash backed Q table playing snake
  ![q_table](https://github.com/rjlynch/ai_snake/assets/9936028/eb32dd25-99d0-4843-ab3e-f1602433864d)


  ## Deep Q table playing snake
  ![deep_q_table](https://github.com/rjlynch/ai_snake/assets/9936028/24feddce-9885-4004-ae3c-1563cb699e43)

