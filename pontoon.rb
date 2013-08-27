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
    if has_a_hand?
      cards = []
      @hand.each { |card| cards << "#{card.to_s}" }
      cards.join(", ")
    else
      "No cards in hand"
    end
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
    
    begin
      new_cards = @deck.deal(hands_to_deal * 2)
    rescue
      puts "Starting a new deck of cards."
      @deck = DeckOfCards::Deck.new
      new_cards = @deck.deal(hands_to_deal * 2)
    end

    new_cards.each_slice(hands_to_deal) do |round_of_cards|
      @players.each { |player| player.hand << round_of_cards.pop }
      @banker.hand << round_of_cards.pop
    end
    @hands_played += 1
  end

  def play_round
    raise StandardError.new(
      'No cards. Deal a round of cards to play.') unless @hands_played > 0
    
    @players.each do |player|
      player_hand_value = face_value_of_hand(player.hand)

      puts "#{player.name} has #{player.hand_to_s}. " +
        "Total: #{player_hand_value}. Stick or twist?"
      until bust(player.hand)
        print "> "; choice = gets.chomp.downcase
        if choice == "stick" || choice == "s"
          break
        elsif choice == "twist" || choice == "t"
          new_card = @deck.deal.first
          player.hand << new_card
          puts "#{player.name} twists...#{new_card.to_s}. " +
            "Total: #{player_hand_value}."
        else
          puts "Say again?"
        end
      end
      if bust(player.hand)
        puts "#{player.name} is bust! #{player.hand_to_s}. " +
          "Total: #{player_hand_value}"
      else
        puts "#{player.name} sticks with #{player.hand_to_s}. " +
          "Total: #{player_hand_value}"
      end
    end
  end

  def face_value_of_hand(hand)
    face_value = 0
    aces = 0
    hand.each do |card|
      if card.face_value.is_a?(Integer)
        face_value += card.face_value
      elsif card.face_value == "Ace"
        face_value += 1
        aces += 1
      else
        face_value += 10
      end
    end
    while aces > 0
      if face_value + 10 <= 21
        face_value += 10
        aces -= 1
      else
        break
      end
    end
    face_value
  end

  def bust(hand)
    face_value_of_hand(hand) > 21
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
    players_hands + "\n" + bankers_hand
  end
end

game = Pontoon.new