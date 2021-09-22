import 'package:flutter/material.dart';

class FlagCount extends StatelessWidget {
  int number;

  // Counter für die flaggen die übrig sin
  FlagCount({this.number});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.black,
          border: Border(
            right: BorderSide(width: 2, color: Colors.white),
            bottom: BorderSide(width: 2, color: Colors.white),
            top:
                BorderSide(width: 2, color: Color.fromARGB(255, 128, 128, 128)),
            left:
                BorderSide(width: 2, color: Color.fromARGB(255, 128, 128, 128)),
          )),
      padding: EdgeInsets.all(1),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AspectRatio(
            aspectRatio: 0.5,
            child: Container(
              color: Colors.black,

              child: Image.asset(
                // Nummern abhängig, siehe images
                  'assets/images/${(this.number / 100).floor() % 10}.png'),
            ),
          ),
          AspectRatio(
            aspectRatio: 0.5,
            child: Container(
              color: Colors.black,
              child: Image.asset(
                  'assets/images/${(this.number / 10).floor() % 10}.png'),
            ),
          ),
          AspectRatio(
            aspectRatio: 0.5,
            child: Container(
              color: Colors.black,
              child: Image.asset('assets/images/${(this.number % 10)}.png'),
            ),
          ),
        ],
      ),
    );
  }
}
