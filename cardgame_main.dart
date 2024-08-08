import 'package:flutter/material.dart';
import 'game_logic.dart';

void main() {
  runApp(CardGameApp());
}

class CardGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Card Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CardGameHomePage(),
    );
  }
}

class CardGameHomePage extends StatefulWidget {
  @override
  _CardGameHomePageState createState() => _CardGameHomePageState();
}

class _CardGameHomePageState extends State<CardGameHomePage> {
  CardGame game = CardGame();

  void _drawCard() {
    setState(() {
      game.drawCard();
    });
  }

  void _discardCard(String card) {
    setState(() {
      game.discardCard(card);
    });
  }

  void _meldCards(String meld) {
    setState(() {
      game.meldCards(meld.split(',').map((card) => card.trim()).toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Card Game'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text('Your Hand:', style: TextStyle(fontSize: 18)),
            Expanded(
              child: GridView.count(
                crossAxisCount: 4,
                children: game.getPlayerHand().map((card) {
                  return GestureDetector(
                    onTap: () {
                      _discardCard(card);
                    },
                    child: Card(
                      child: Center(child: Text(card, textAlign: TextAlign.center)),
                    ),
                  );
                }).toList(),
              ),
            ),
            ElevatedButton(
              onPressed: _drawCard,
              child: Text('Draw Card'),
            ),
            ElevatedButton(
              onPressed: () {
                final meld = showDialog<String>(
                  context: context,
                  builder: (BuildContext context) {
                    return _MeldDialog();
                  },
                ).then((meld) {
                  if (meld != null && meld.isNotEmpty) {
                    _meldCards(meld);
                  }
                });
              },
              child: Text('Meld Cards'),
            ),
            SizedBox(height: 20),
            Text('Discard Pile:', style: TextStyle(fontSize: 18)),
            if (game.getDiscardPile().isNotEmpty)
              Text(game.getDiscardPile().last),
            SizedBox(height: 20),
            Text('Stockpile: ${game.getStockpileInfo().length} cards remaining'),
          ],
        ),
      ),
    );
  }
}

class _MeldDialog extends StatefulWidget {
  @override
  _MeldDialogState createState() => _MeldDialogState();
}

class _MeldDialogState extends State<_MeldDialog> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Enter Cards to Meld'),
      content: TextField(
        controller: _controller,
        decoration: InputDecoration(hintText: 'e.g. 2 of Hearts, 3 of Diamonds'),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(_controller.text);
          },
          child: Text('Meld'),
        ),
      ],
    );
  }
}
