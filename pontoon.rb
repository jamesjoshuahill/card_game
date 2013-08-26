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
    not @hand.empty?
  end

  def hand_to_s
    cards = []
    @hand.each { |card| cards << "#{card.to_s}" }
    cards.join(", ")
  end
end


class Pontoon
  attr_reader :num_of_players, :players

  def initialize(num_of_players=1)
    @banker = CardPlayer.new('Banker')

    @num_of_players = num_of_players
    @players = []
    @num_of_players.times do |num|
      print "Please enter player #{num + 1}'s name:  "
      @players << CardPlayer.new(gets.chomp)
    end

    @deck = DeckOfCards::Deck.new
    @discard_pile = []
    @hands_played = 0
  end

  def deal_round
    clear_table
    
    hands_to_deal = num_of_players + 1
    new_cards = @deck.deal(hands_to_deal * 2)

    new_cards.each_slice(hands_to_deal) do |round_of_cards|
      @players.each { |player| player.hand.concat round_of_cards.pop }
      @banker.hand.concat round_of_cards.pop
    end
    @hands_played += 1
  end

  def clear_table
    @discard_pile.concat @banker.discard_hand
    @players.each { |player| @discard_pile.concat player.discard_hand }
  end

  def game_over?
    #to be implemented...

  end

  def players_hands
    @players.map { |player| "#{player.name}: #{player.hand_to_s}." }.join("\n")
  end

  def bankers_hand
    "#{@banker.name}: #{@banker.hand_to_s}."
  end

  def cards_on_the_table
    show_players_hands + "\n" + show_bankers_hand
  end

  def hands_played
    "Hands played #{@hands_played}."
  end
end

game = Pontoon.new