import 'dart:math';

class CardGame {
  List<String> ranks = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A'];
  List<String> suits = ['Hearts', 'Diamonds', 'Clubs', 'Spades'];
  List<String> deck = [];
  List<String> stockpile = [];
  List<String> discardPile = [];
  List<List<String>> hands = [];

  CardGame() {
    _initializeGame();
  }

  void _initializeGame() {
    deck = [];
    for (var suit in suits) {
      for (var rank in ranks) {
        deck.add('$rank of $suit');
      }
    }
    deck.add('Joker');
    deck.add('Joker');
    _shuffleDeck();
    _dealCards(4);
  }

  void _shuffleDeck() {
    deck.shuffle(Random());
  }

  void _dealCards(int numPlayers) {
    hands = List.generate(numPlayers, (_) => []);
    for (var i = 0; i < 14; i++) {
      for (var hand in hands) {
        hand.add(deck.removeLast());
      }
    }
    hands[0].add(deck.removeLast()); // Dealer gets one extra card
    stockpile = deck;
    deck = [];
  }

  String drawCard({bool fromDiscard = false}) {
    if (fromDiscard && discardPile.isNotEmpty) {
      var card = discardPile.removeLast();
      hands[0].add(card);
      return card;
    } else if (stockpile.isNotEmpty) {
      var card = stockpile.removeLast();
      hands[0].add(card);
      return card;
    }
    return null;
  }

  void discardCard(String card) {
    if (hands[0].contains(card)) {
      hands[0].remove(card);
      discardPile.add(card);
    }
  }

  void meldCards(List<String> cards) {
    for (var card in cards) {
      if (hands[0].contains(card)) {
        hands[0].remove(card);
      }
    }
  }

  List<String> getPlayerHand() => hands[0];
  List<String> getStockpileInfo() => stockpile;
  List<String> getDiscardPile() => discardPile;
}
