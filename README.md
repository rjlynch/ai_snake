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

  To train a q table to play snake run

  ```
  bundle exec ruby main.rb q_table
  ```

  The q table approach needs some work as it doesn't seem to converge on a
  solution, though it learns to avoid danger quite quickly. The neural net
  deep q table can play the game pretty well after 4000 games.

  The action kicks off in the file `main.rb` so best to review that first.
  Hyper parameters can be tweaked in `hyper_parameters.rb`

  The agent uses a q learning based approach to learn the game, backed by
  either an in memory q table or a neural net modeling a q table depending
  on how it's configured.

  ## Neural net scoring 24 points after learning from 4K games
  

https://github.com/rjlynch/ai_snake/assets/9936028/668c4c3b-858c-400e-9884-5f9394d19702

