
class HangmanGame
    attr_accessor :secret_word, :guessed_letters, :incorrect_letters, :remaining_guesses
  
    def initialize
      @dictionary = download_dictionary # Implement a method to download the dictionary
      @secret_word = select_random_word
      @guessed_letters = []
      @incorrect_letters = []
      @remaining_guesses = 6
    end
  
    def download_dictionary
        dictionary_file = "hangman.txt"

        if File.exist?(dictionary_file)
          words = File.readlines(dictionary_file).map(&:strip)
          return words
        else
          puts "Error: The dictionary file '#{dictionary_file}' not found."
          return []
        end
   
    end
  
    def select_random_word
      valid_words = @dictionary.select { |word| word.length >= 5 && word.length <= 12 }
      random_word = valid_words.sample
      return random_word
    end
  
    def display_word
      word_display = @secret_word.chars.map do |letter|
        if @guessed_letters.include?(letter)
          letter
        else
          '_'
        end
      end
  
      puts "Current word: #{word_display.join(' ')}"
    end
  
    def display_status
      puts "Remaining Guesses: #{@remaining_guesses}"
      puts "Guessed Letters: #{@guessed_letters.join(', ')}"
      puts "Incorrect Letters: #{@incorrect_letters.join(', ')}"
    end
  
    def make_guess(letter)
      letter = letter.downcase
      if @guessed_letters.include?(letter) || @incorrect_letters.include?(letter)
        puts "You've already guessed that letter."
        return
      end
  
      if @secret_word.include?(letter)
        @guessed_letters << letter
        puts "Correct guess!"
      else
        @incorrect_letters << letter
        @remaining_guesses -= 1
        puts "Incorrect guess. #{@remaining_guesses} guesses remaining."
      end
    end
  
    def game_over?
      if @remaining_guesses.zero?
        puts "Game Over! Correct word was #{@secret_word}."
        return true
      elsif @secret_word.chars.all? { |letter| @guessed_letters.include?(letter) }
        puts "You Won! Correct word was #{@secret_word}."
        return true
      else
        return false
      end
    end
  
    def save_game(filename)
      File.open(filename, 'wb') do |file|
        file.write(Marshal.dump(self))
      end
      puts "Game saved successfully."
    end
  
    def self.load_game(filename)
      if File.exist?(filename)
        File.open(filename, 'rb') do |file|
          game = Marshal.load(file.read)
          return game
        end
      else
        puts "Error: The file #{filename} does not exist."
        return nil
      end
    end
end 

  # The main program
  puts "Hangman Game"
  puts "1. New Game"
  puts "2. Load Game"
  choice = gets.chomp.to_i
  
  if choice == 1
    game = HangmanGame.new
  elsif choice == 2
    puts "Enter the filename of the saved game:"
    filename = gets.chomp
    game = HangmanGame.load_game(filename)
  end
  
  # Game loop
  until game.game_over?
    game.display_word
    game.display_status
    puts "Enter a letter to guess or 'save' to save the game:"
    input = gets.chomp
  
    if input.downcase == 'save'
      puts "Enter the filename to save the game:"
      filename = gets.chomp
      game.save_game(filename)
    else
      game.make_guess(input)
    end
  end