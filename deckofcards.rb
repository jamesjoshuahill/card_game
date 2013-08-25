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
  end

  class Deck
    attr_reader :full_deck
    SUITS = %w{Hearts Diamonds Spades Clubs}
    FACE_VALUES = (2..10).to_a.concat %w{Jack Queen King Ace}

    def initialize
      @deck = Array.new
      SUITS.each do |suit|
        FACE_VALUES.each { |face_value| @deck << Card.new(face_value, suit) }
      end
      @full_deck = true
    end

    def to_s
      @deck.map { |card| card.to_s }.to_s
    end

    def each
      @deck.each { |card| yield card }
    end

    def full_deck?
      @full_deck
    end

    def shuffle
      @deck.shuffle!
    end

    def deal(num=1)
      @full_deck = false
      @deck.pop(num)
    end

    def count
      @deck.count
    end

    def empty?
      @deck.empty?
    end
  end

end