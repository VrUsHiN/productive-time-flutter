import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:productivetimeflutter/quotes_data.dart';

class QuoteContainer extends StatefulWidget {
  @override
  _QuoteContainerState createState() => _QuoteContainerState();
}

class _QuoteContainerState extends State<QuoteContainer> {
  Timer timer;
  String quoteTitle;
  String quoteAuthor;

  @override
  void initState() {
    super.initState();
    generateNewQuote();
    timer = Timer.periodic(Duration(minutes: 5), (Timer t) => generateNewQuote());
  }

  void generateNewQuote(){
    int randomQuoteIndex = Random().nextInt(quotes.length);
    setState(() {
      quoteTitle = quotes[randomQuoteIndex]['title'];
      quoteAuthor = quotes[randomQuoteIndex]['author'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        //color: Colors.orange,
        borderRadius: BorderRadius.circular(15.0),
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            '“ $quoteTitle ”',
            softWrap: true,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
              fontFamily: 'CormorantGaramond',
            ),
          ),
          SizedBox(height: 15),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              '- $quoteAuthor',
              softWrap: true,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                fontFamily: 'CormorantGaramond',
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
