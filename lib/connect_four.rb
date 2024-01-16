# frozen_string_literal: true

# Our entire game of connect four is ran through this single class
class ConnectFour
  attr_accessor :board_array

  def initialize
    @board = [
      [nil, nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil]
    ]
    @player_one = "\e[31mO\e[0m" # Red letter 'O'
    @player_two = "\e[33mO\e[0m" # Yellow letter 'O'
    @current_player = @player_one
  end

  def play_game
    loop do
      display_player
      puts "Choose a column between 0 and 6 that isn't full."
      display_board
      column = gets.chomp.to_i
      break unless valid_input?(column)
    end
  end

  def valid_input?(column)
    if (0..6).include?(column) && @board[0][column].nil?
      player_input(column, @current_player)
    else
      puts 'Invalid choice.'
      play_game
    end
  end

  def player_input(column, current_player)
    row = 5

    while row >= 0
      if @board[row][column].nil?
        @board[row][column] = current_player
        break
      end

      row -= 1
    end

    game_over?
  end

  def game_over?
    # First, check for a horizontal combination of four tokens
    if horizontal_victory? then new_game?
    # If not available, check for a vertical combination of four tokens
    elsif vertical_victory? then new_game?
    # If also not available, check for a diagonal combination of four tokens
    elsif diagonal_victory? then new_game?
    # If no victory conditions are met, switch our current player and resume the game
    else
      switch_player
      play_game
    end
  end

  def switch_player
    @current_player = @current_player == @player_one ? @player_two : @player_one
  end

  def new_game?
    display_winner
    puts "Would you like to play again? Type 'YES' if you do, or anything else if you don't."
    choice = gets.chomp.upcase
    choice == 'YES' ? setup_new_game : (puts 'Thank you for playing!')
  end

  def setup_new_game
    @board = [
      [nil, nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil]
    ]
    @player_one = "\e[31mO\e[0m" # Red letter 'O'
    @player_two = "\e[33mO\e[0m" # Yellow letter 'O'
    @current_player = @player_one
    play_game
  end

  # The methods below are used for checking our victory conditions

  def horizontal_victory?
    @board.flatten.each_cons(4).any? { |group| group.all?(@current_player) }
  end

  def vertical_victory?
    7.times do |column|
      temp_array = []
      6.times do |row|
        temp_array.push(@board[row][column])
        return true if temp_array.each_cons(4).any? { |group| group.all?(@current_player) }
      end
    end

    false
  end

  def diagonal_victory?
    rows = @board.size
    columns = @board[0].size

    # Check diagonals from top-left to bottom-right
    (0..rows - 4).each do |row|
      (0..columns - 4).each do |column|
        tokens = (0..3).map { |i| @board[row + i][column + i] }
        return true if tokens.compact.length == 4 && tokens.uniq.length == 1
      end
    end

    # Check diagonals from bottom-left to top-right
    (3..rows - 1).each do |row|
      (0..columns - 4).each do |column|
        tokens = (0..3).map { |i| @board[row - i][column + i] }
        return true if tokens.compact.length == 4 && tokens.uniq.length == 1
      end
    end

    false
  end

  # The methods below are used for graphical reasons only

  def display_board
    puts ''
    puts '  0   1   2   3   4   5   6'
    puts '+---+---+---+---+---+---+---+'

    @board.each do |row|
      puts "| #{row.map { |cell| cell.nil? ? ' ' : cell }.join(' | ')} |"
      puts '+---+---+---+---+---+---+---+'
    end
  end

  def display_player
    @current_player == @player_one ? (puts "Player one, it's your turn!") : (puts "Player two, it's your turn!")
  end

  def display_winner
    display_board
    @current_player == @player_one ? (puts 'Player one is the winner!') : (puts 'Player two is the winner!')
  end
end

# Remove these if you want to run RSpec tests

game = ConnectFour.new
game.play_game
