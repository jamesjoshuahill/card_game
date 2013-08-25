require './deckofcards'

class CardPlayer
  attr_reader :name
  attr_accessor :hand, :score

  def initialize(name)
    @name = name
    @hand = []
    @score = 0
  end

  def discard_hand
    discards, @hand = @hand, []
    discards
  end

  def has_a_hand?
    @hand.empty?
  end

  def hand_to_s
    cards = []
    @hand.each { |card| cards << "#{card.to_s}" }
    cards.join(", ") << "."
  end
end


class Pontoon
  attr_reader :num_of_players, :players

  def initialize(num_of_players=1)
    @num_of_players = num_of_players
    @deck = DeckOfCards::Deck.new
    @discard_pile = []
    @players = []
    @num_of_players.times do |num|
      print "Please enter player #{num + 1}'s name:  "
      @players << CardPlayer.new(gets.chomp())
    end
    @game_over = false

    deal_round
  end

  def deal_round
    @players.each do |player|
      @discard_pile.concat player.discard_hand
    end
    2.times do
      @players.each { |player| player.hand.concat @deck.deal }
    end
  end

  def game_over?
    @game_over
  end

  def show_players_hands
    @players.map { |player| "#{player.name}: #{player.hand_to_s}" }.join(' ')
  end
end

game = Pontoon.new