module DeckOfCards
  SUITS = %w{Hearts Diamonds Spades Clubs}
  FACE_VALUES = (2..10).to_a.concat %w{Jack Queen King Ace}

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
    def initialize
      @deck = Array.new
      SUITS.each do |suit|
        FACE_VALUES.each { |face_value| @deck << Card.new(face_value, suit) }
      end
      shuffle!
    end

    def to_s
      @deck.map { |card| card.to_s }.join(', ')
    end

    def shuffle!
      @deck.shuffle!
    end

    def deal(num=1)
      raise ArgumentError.new(
        "Not enough cards left to deal #{num}.") unless self.count >= num
      
      @deck.pop(num)
    end

    def count
      @deck.count
    end

    def empty?
      @deck.empty?
    end

    def include?(card)
      @deck.any? { |card_in_deck| card == card_in_deck }
    end

    def full_deck?
      @deck.uniq.count == 52
    end
  end

end