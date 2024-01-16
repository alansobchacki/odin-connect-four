# frozen_string_literal: true

require '../lib/connect_four'

one = "\e[31mO\e[0m" # representation of player_one tokens
two = "\e[33mO\e[0m" # representation of player_two tokens

describe ConnectFour do
  describe '#player_input' do
    subject(:game) { described_class.new }

    before do
      allow(game).to receive(:game_over?).and_return(false)
    end

    context 'when player one provides a valid input' do
      it 'updates the last row with their player token' do
        player_one = game.instance_variable_get(:@player_one)
        game.player_input(3, player_one)

        expected_board = [
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, one, nil, nil, nil]
        ]

        expect(game.instance_variable_get(:@board)).to eq(expected_board)
      end
    end

    context 'when player two provides a valid input after player one made their move' do
      it 'updates the last row with their player token' do
        player_one = game.instance_variable_get(:@player_one)
        player_two = game.instance_variable_get(:@player_two)
        game.player_input(3, player_one)
        game.player_input(4, player_two)

        expected_board = [
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, one, two, nil, nil]
        ]

        expect(game.instance_variable_get(:@board)).to eq(expected_board)
      end
    end

    context 'when player one provides a valid input in a column that was already chosen' do
      it 'updates the chosen column with their player token' do
        player_one = game.instance_variable_get(:@player_one)
        player_two = game.instance_variable_get(:@player_two)
        game.player_input(3, player_one)
        game.player_input(4, player_two)
        game.player_input(3, player_one)

        expected_board = [
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, one, nil, nil, nil],
          [nil, nil, nil, one, two, nil, nil]
        ]

        expect(game.instance_variable_get(:@board)).to eq(expected_board)
      end
    end
  end

  describe '#valid_input?' do
    subject(:game) { described_class.new }

    before do
      allow(game).to receive(:play_game).and_return(false)
    end

    context 'when a player correctly chooses between column 0 to 6' do
      it 'does not display any error messages' do
        expect { game.valid_input?(6) }.not_to output.to_stdout
      end

      it 'allows the game to continue as usual' do
        game.valid_input?(6)
        last_row = game.instance_variable_get(:@board)[-1]
        expect(last_row).to include("\e[31mO\e[0m").or include("\e[31mO\e[0m")
      end
    end

    context 'when a player chooses a column outside the range of 0 to 6' do
      it 'displays an error message' do
        error_message = "Invalid choice.\n"
        expect { game.valid_input?(8) }.to output(error_message).to_stdout
      end
    end

    context 'when a player chooses a value that is not a number' do
      it 'displays an error message' do
        error_message = "Invalid choice.\n"
        expect { game.valid_input?('b') }.to output(error_message).to_stdout
      end
    end
  end

  describe '#game_over?' do
    subject(:game) { described_class.new }

    before do
      allow(game).to receive(:play_game).and_return(false)
    end

    context 'when a player forms a horizontal line of four tokens' do
      it 'ends the game' do
        game.instance_variable_set(:@board,
        [
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, two, two, two, nil, nil, nil],
          [nil, one, one, one, one, nil, nil]
        ])

        expect(game.horizontal_victory?).to eq(true)
      end
    end

    context 'when a player forms a vertical line of four tokens' do
      it 'ends the game' do
        game.instance_variable_set(:@board,
        [
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, one, nil, nil, nil, nil, nil],
          [nil, one, nil, nil, nil, nil, nil],
          [nil, one, two, nil, nil, nil, nil],
          [nil, one, two, two, nil, nil, nil]
        ])

        expect(game.vertical_victory?).to eq(true)
      end
    end

    context 'when a player forms a diagonal line of four tokens from bottom-left to upper-right' do
      it 'ends the game' do
        game.instance_variable_set(:@board,
        [
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, one, nil, nil],
          [nil, nil, nil, one, one, nil, nil],
          [nil, two, one, one, two, nil, nil],
          [nil, one, two, two, two, nil, nil]
        ])

        expect(game.diagonal_victory?).to eq(true)
      end
    end

    context 'when a player forms a diagonal line of four tokens from bottom-right to upper-left' do
      it 'ends the game' do
        game.instance_variable_set(:@board,
        [
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, one, one, one, nil, nil],
          [nil, nil, one, one, one, two, nil],
          [nil, two, one, one, two, one, nil],
          [two, one, two, two, two, two, one]
        ])

        expect(game.diagonal_victory?).to eq(true)
      end
    end
  end
end
