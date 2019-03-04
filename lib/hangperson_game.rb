class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end

  attr_accessor :word
  attr_accessor :guesses
  attr_accessor :wrong_guesses
  
  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
    @check_status = :play
  end

  # You can test it by running $ bundle exec irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.new('watchout4snakes.com').start { |http|
      return http.post(uri, "").body
    }
  end

  # Processes a game and modifies the @guesses and @wrong_guesses variables accordingly
  def guess(letter_guess) 
    if letter_guess == '' or letter_guess == nil or !letter_guess.match(/[A-Za-z]/)
      raise ArgumentError.new("invalid")
    end

    if word.include?(letter_guess) and !@guesses.include?(letter_guess) and letter_guess.match(/[a-z]/)
      @guesses += letter_guess
      return true
    elsif !word.include?(letter_guess) and !@wrong_guesses.include?(letter_guess) and letter_guess.match(/[a-z]/)
      @wrong_guesses += letter_guess
      return true
    else
      return false
    end
  end

  # Returns one of the symbols :win, :lose or :play depending on the current game state 
  def check_win_or_lose
    if @wrong_guesses.length >= 7
      return :lose
    elsif !word_with_guesses.include?('-')
      return :win
    else
      return :play
    end
  end

  # Substitues the correct guesses made so far into the word
  def word_with_guesses
    word.gsub(/[^ #{guesses}]/, '-')
  end
end
