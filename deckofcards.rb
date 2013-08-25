module DeckOfCards

  class Card
    attr_reader :face_value, :suit

    def initialize(face_value, suit)
      @face_value = face_value
      @suit = suit
    end

    def to_s
      "#{@face_value} of #{@suit}"
    end

    def ==(other_card)
      @face_value == other_card.face_value && @suit == other_card.suit
    end
  end

  class Deck
    SUITS = %w{Hearts Diamonds Spades Clubs}
    FACE_VALUES = (2..10).to_a.concat %w{Jack Queen King Ace}

    def initialize
      @deck = Array.new
      SUITS.each do |suit|
        FACE_VALUES.each { |face_value| @deck << Card.new(face_value, suit) }
      end
      @discard_pile = []
    end

    def to_s
      @deck.map { |card| card.to_s }.to_s
    end

    def shuffle!
      @deck.shuffle!
    end

    def restart_deck
      @deck = @deck.concat @discard_pile if self.whole_pack?
      @deck.shuffle!
    end

    def deal(num=1)
      raise ArgumentError.new(
        'Not enough cards left to deal.') unless self.count >= num
      @deck.pop(num)
    end

    def count
      @deck.count
    end

    def empty?
      @deck.empty?
    end

    def discard(cards)
      cards.each do |discard|
        raise ArgumentError.new('Duplicate Card. Cannot add a card to the ' +
          'discard pile that is in the deck.') if @deck.include?(discard)
      end
      @discard_pile.concat cards
    end

    def include?(card)
      @deck.any? { |card_in_deck| card == card_in_deck }
    end

    def clean_deck?
      @deck.count == 52
    end

    def whole_pack?
      @deck.concat(@discard_pile).uniq.count == 52
    end
  end

end